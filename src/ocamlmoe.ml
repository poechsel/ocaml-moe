[@@@warning "-39"]

open! Core

(* WARNING, PROBABLY SHOULD FIXED THE DEFAULTS BECAUSE
   THEY ARE NOT EMITTED IN THE OUTPUT

   See to adapt: https://github.com/openvstorage/alba/pull/422
*)

let body =
  let server = Moe.Server.create ~host:"127.0.0.1" ~port:6543 in
  let gp_historical_info : Moe.Common.gp_historical_info =
    {points_sampled= []}
  in
  let domain_info : Moe.Common.bounded_domain_info =
    { domain_type= TENSOR_PRODUCT_DOMAIN_TYPE
    ; dim= 4
    ; domain_bounds= [{min= 0.0; max= 2.0}] }
  in
  let request =
    Moe.Nextpoints.EpiNewton.create ~gp_historical_info ~domain_info ()
  in
  Lwt.bind
    (Moe.Server.get (module Moe.Nextpoints.EpiNewton) ~request server)
    (fun response ->
      response |> Moe.Nextpoints.EpiNewton.response_to_yojson
      |> Yojson.Safe.to_string |> print_endline |> Lwt.return )

let () = Lwt_main.run body

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
