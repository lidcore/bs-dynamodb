type params = <
  key: string
> Js.t

type attributes = <
  id:    string;
  key:   string;
  state: string [@bs.set]
> Js.t

type model  = <attrs:attributes> Js.t

val create_table : unit BsCallback.t
val create       : params -> model BsCallback.t
val get          : string -> model option BsCallback.t
val set_state    : model -> string -> model BsCallback.t
val update       : attributes -> model option BsCallback.t
