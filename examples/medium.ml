open Callback

let uuid : unit -> string [@bs] = [%bs.raw{|function() {
  require("uuid/v1")();
}|}]

module Definition = struct
  open Dynamodb

  type params = <
    key: string
  > Js.t

  type attributes = <
    id:    string;
    key:   string;
    state: string [@bs.set]
  > Js.t

  let name       = "Media"
  let hashKey    = "id"
  let timestamps = true
  let specs = 
    let specs = [
      Specs.string "id";
      Specs.string "key"
    ] in
    List.fold_left (fun spec str ->
      str spec) (Specs.make ()) specs
  let table_name = "media"
end

module Model = Dynamodb.Make(Definition)

include Model

external set_id : params -> string -> unit = "id" [@@bs.set]

let create params =
  set_id params (uuid () [@bs]);
  create params

external make_error : string -> exn = "Error" [@@bs.new]

let set_state model state =
  let attrs = model##attrs in
  attrs##state #= state;
  update attrs >> fun model ->
    match model with
      | Some model -> Callback.return model
      | None -> Callback.fail (make_error "Inconsistent state update (should not happen)")
