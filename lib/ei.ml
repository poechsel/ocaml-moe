[@@@warning "-39"]

open Common

let endpoint = "/gp/ei"

type request =
  { points_to_evaluate: list_of_points_in_domain
  ; points_being_sampled: list_of_points_in_domain [@default []]
  ; mc_iterations: int [@default 10000]
  ; max_num_threads: int [@default 4]
  ; gp_historical_info: gp_historical_info
  ; domain_info: domain_info
  ; covariance_info: covariance_info
  (*in theory it has a default value *) }
[@@deriving yojson]

let create ?(points_being_sampled= []) ?(mc_iterations= 10000)
    ?(max_num_threads= 4) ?(covariance_info= default_covariance_info)
    ~points_to_evaluate ~gp_historical_info ~domain_info =
  { points_to_evaluate
  ; points_being_sampled
  ; mc_iterations
  ; max_num_threads
  ; gp_historical_info
  ; domain_info
  ; covariance_info }

type response =
  {endpoint: string; expected_improvement: list_of_expected_improvements}
[@@deriving yojson]
