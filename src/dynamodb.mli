type credentials = <
  accessKeyId:     string [@bs.set] [@bs.get nullable];
  secretAccessKey: string [@bs.set] [@bs.get nullable];
  region:          string [@bs.set] [@bs.get nullable]
> Js.t

val update_credentials : credentials -> unit

module Specs : sig
  type spec
  val make   : unit -> spec
  val string : ?required:bool -> string -> spec -> spec
  val obj    : ?required:bool -> string -> spec -> spec
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

module Make : functor (Def:Definition_t) -> Model_t with type params = Def.params and type attributes = Def.attributes
