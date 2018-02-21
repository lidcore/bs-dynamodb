open Callback

[%%bs.raw{|var dynamodb = require("dynamodb")|}]

type credentials = <
  accessKeyId:     string [@bs.set] [@bs.get nullable];
  secretAccessKey: string [@bs.set] [@bs.get nullable];
  region:          string [@bs.set] [@bs.get nullable]
> Js.t

external update_credentials : credentials -> unit = "" [@@bs.val "dynamodb.AWS.config.update"]

type dynamodb
external dynamodb : dynamodb = "" [@@bs.val "dynamodb"]

module Specs = struct
  type spec
  type spec_value
  external make : unit -> spec = "" [@@bs.obj]

  let spec_set : spec -> string -> spec_value -> spec [@bs] = [%bs.raw{|function(obj,lbl,value){
    obj[lbl] = value;
    return obj;
  }|}]

  type joi
  external joi : joi = "" [@@bs.module]
  external str_spec : joi -> unit -> spec_value = "" [@@bs.send "string"]
  external obj_spec : joi -> unit -> spec_value = "" [@@bs.send "object"]
  external req_spec : spec_value -> unit -> spec_value = "" [@@bs.send "required"]

  let make_spec fn ?(required=true) name spec =
    let spec_value =
      fn joi ()
    in
    let spec_value =
      if required then
        req_spec spec_value ()
      else
        spec_value
    in
    spec_set spec name spec_value [@bs]

    let string = make_spec str_spec
    let obj = make_spec obj_spec
end

module type Definition_t = sig
  type params
  type attributes
  val name       : string
  val hashKey    : string
  val timestamps : bool
  val specs      : Specs.spec
  val table_name : string
end

module type Model_t = sig
  type params
  type attributes
  type model = <attrs:attributes> Js.t
  val create_table : unit Callback.t
  val create : params -> model Callback.t
  val get    : string -> model option Callback.t
  val update : attributes -> model option Callback.t
end

module Make(Def:Definition_t) : Model_t with type params = Def.params and type attributes = Def.attributes = struct
  type params     = Def.params
  type attributes = Def.attributes
  type model   = <attrs:attributes> Js.t
  
  type definition
  external make_definition : hashKey:string -> timestamps:Js.boolean -> schema:Specs.spec -> unit -> definition = "" [@@bs.obj] 

  type model_class
  external define : dynamodb -> string -> definition -> model_class = "" [@@bs.send] 
  let make_model_class () =
    let timestamps =
      Js.Boolean.to_js_boolean Def.timestamps
    in
    let definition =
      make_definition ~hashKey:Def.hashKey ~timestamps ~schema:Def.specs ()
    in
    define dynamodb Def.table_name definition

  let model_class = make_model_class ()

  external create_table : model_class -> unit Callback.callback -> unit = "createTable" [@@bs.send]
  let create_table = create_table model_class

  external create : model_class -> params -> model Callback.callback -> unit = "" [@@bs.send]
  let create = create model_class

  let to_opt = fun value ->
    Callback.return (Js.Nullable.to_opt value)

  external get : model_class -> string -> model Js.Nullable.t Callback.callback -> unit = "" [@@bs.send]
  let get id =
    get model_class id >> to_opt

  external update : model_class -> attributes -> model Js.Nullable.t Callback.callback -> unit = "" [@@bs.send]
  let update attributes =
    update model_class attributes >> to_opt
end
