open! Common
open! Core
open! Lwt
open! Cohttp
open! Cohttp_lwt_unix

let unzip x = match x with Ok x -> x | Error s -> raise_s (Atom s)

module Server = struct
  type t = {host: string; port: int}

  let build_url t endpoint =
    "http://" ^ t.host ^ ":" ^ string_of_int t.port ^ endpoint

  let get (type a b) (module Endpoint
      : Endpoint with type request = a and type response = b) ~(request: a) t :
      b Lwt.t =
    let body =
      let s = request |> Endpoint.request_to_yojson |> Yojson.Safe.to_string in
      print_endline s ;
      s |> Cohttp_lwt.Body.of_string
    in
    let () = print_endline (build_url t Endpoint.endpoint) in
    let uri = Uri.of_string (build_url t Endpoint.endpoint) in
    Client.post ~body uri
    >>= fun (_, body) ->
    body |> Cohttp_lwt.Body.to_string
    >|= fun body ->
    print_endline body ;
    body |> Yojson.Safe.from_string |> Endpoint.response_of_yojson |> unzip

  let create ~host ~port = {host; port}
end

module Ei = Ei
module Nextpoints = Nextpoints
module Common = Common
module Hyperopt = Hyperopt
module Mean = Mean
