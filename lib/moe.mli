module Server : sig
  type t

  val create : host:string -> port:int -> t

  val get :
       (module Common.Endpoint with type request = 'a and type response = 'b)
    -> request:'a
    -> t
    -> 'b Lwt.t
end

module Ei = Ei
module Nextpoints = Nextpoints
module Common = Common
module Hyperopt = Hyperopt
module Mean = Mean
