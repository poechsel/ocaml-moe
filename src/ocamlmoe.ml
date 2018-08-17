[@@@warning "-39"]
open Common
open! Core
open Lwt
open! Cohttp
open! Cohttp_lwt_unix

let unzip x =
  match x with
  | Ok x -> x
  | Error s -> raise_s (Atom s)

module MoeServer = struct
  type t = {
    host: string;
    port: int
  }

  let build_url t endpoint =
    "http://" ^ t.host ^ ":" ^ string_of_int t.port ^ endpoint

  let get (type a) (type b) (module Endpoint : Endpoint with type request = a and type response = b)
        (request : a) t : b Lwt.t =
    let body =
      let s = request
      |> Endpoint.request_to_yojson
      |> Yojson.Safe.to_string
           in
        print_endline s ;   
      s |> Cohttp_lwt.Body.of_string
    in
    let () = print_endline (build_url t Endpoint.endpoint) in
    let uri = Uri.of_string (build_url t Endpoint.endpoint) in
    Client.post ~body uri
    >>= (fun (_, body) ->
      body
      |> Cohttp_lwt.Body.to_string
      >|= (fun body ->
        print_endline body;
        body
        |> Yojson.Safe.from_string
        |> Endpoint.response_of_yojson
      |> unzip
      ))

  let create ~host ~port = {host; port}
end

(* gp_ei *)

module GpEi = struct
  let endpoint = "/gp/ei"
  type request = {
    points_to_evaluate : list_of_points_in_domain;
    points_being_sampled : list_of_points_in_domain [@default []];
    mc_iterations : int [@default 10000];
    max_num_threads : int[@default 4];
    gp_historical_info : gp_historical_info;
    domain_info : domain_info;
    covariance_info : covariance_info (*in theory it has a default value *);
  }
  [@@deriving yojson]

  let create
        ?(points_being_sampled = [])
        ?(mc_iterations = 10000)
        ?(max_num_threads = 4)
        ?(covariance_info = default_covariance_info)
        ~points_to_evaluate
        ~gp_historical_info
        ~domain_info
        =
  {
    points_to_evaluate;
    points_being_sampled;
    mc_iterations;
    max_num_threads;
    gp_historical_info;
    domain_info;
    covariance_info;
  }

  type response = {
    endpoint : string;
    expected_improvement : list_of_expected_improvements;
  }
  [@@deriving yojson]
end


module GpHyperOptRequest (Arg : Optimizer) = struct

  let endpoint = "/gp/hyper_opt"
type log_likelihood_info =
  | LEAVE_ONE_OUT_LOG_LIKELIHOOD
  | LOG_MARGINAL_LIKELIHOOD
[@@deriving yojson]


  type request = {
    max_num_threads : int [@default 4];
    gp_historical_info : gp_historical_info;
    domain_info : domain_info;
    covariance_info : covariance_info (* has empty default val *);
    hyperparameter_domain_info : bounded_domain_info;
    optimizer_info : Arg.parameters optimizer_info (* has empty default val *);
    log_likelihood_info : log_likelihood_info [@default LOG_MARGINAL_LIKELIHOOD];
  }
  [@@deriving yojson]

  type status = {
    log_likelihood : float;
    grad_log_likelihood : float list;
    optimizer_success : Yojson.Safe.json (* doesn't really matters for now *);
  }
  [@@deriving yojson]

  type response = {
    endpoint : string;
    covariance_info : covariance_info;
    stats :  status;
  }
  [@@deriving yojson]

end

module GpMean = Mean.GpVar
module GpNextPointsEpi = Gpnextpoints.Epi

(* WARNING, PROBABLY SHOULD FIXED THE DEFAULTS BECAUSE
   THEY ARE NOT EMITTED IN THE OUTPUT

   See to adapt: https://github.com/openvstorage/alba/pull/422
*)


module Test  =
  GpNextPointsEpi(struct type parameters = newton_parameters [@@deriving yojson]  end)
let body =
  let server = MoeServer.create ~host:"127.0.0.1" ~port:6543 in
  let gp_historical_info = {points_sampled = []} in
  let domain_info : bounded_domain_info = {
    domain_type = TENSOR_PRODUCT_DOMAIN_TYPE;
    dim = 4;
    domain_bounds = [ {min=0.0; max=2.0}];
  }
  in
  let request = Test.create ~gp_historical_info
                  ~domain_info ()
  in

  Lwt.bind (MoeServer.get (module Test) request server)
(fun response ->
  response |>
  Test.response_to_yojson |>
  Yojson.Safe.to_string |>
  print_endline
|> Lwt.return )

let () =
  Lwt_main.run body


    (*
   hyper opt status

   kname: log_marginal_likelihood leave_one_out_log_likelihood
   evaluate_ kName _at_hyperparameter_list (klogmarginal kleaveoneout)
   evaluate_invalid_log_likelihood_at_hyperparameter_list (else)


   kname _lhc_found_update (knull)
   kname _gradient_descent_found_update (grad descenet)
   kname _newton_found_update (newton)



   next_point
   found_update
   evaluate_EI_at_point_list
   gradient_descent_found_update
*)
