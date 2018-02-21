type params = <
  key: string
> Js.t

type attributes = <
  id:    string;
  key:   string;
  state: string [@bs.set]
> Js.t

type model  = <attrs:attributes> Js.t

val create_table : unit Callback.t
val create       : params -> model Callback.t
val get          : string -> model option Callback.t
val set_state    : model -> string -> model Callback.t
val update       : attributes -> model option Callback.t
