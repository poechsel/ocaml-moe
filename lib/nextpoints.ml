[@@@warning "-39"]

open Common

(*
type likelihood_status =
  { gradient_descent_found_update: bool
  ; multistart_hyperparameter_optimization: bool }
*)

type next_points_status =
  { expected_improvement: float
  ; optimizer_success: Yojson.Safe.json
  (* for now *) }
[@@deriving yojson]

type next_points_response =
  { endpoint: string
  ; points_to_sample: list_of_points_in_domain
  ; status: next_points_status }
[@@deriving yojson]

module Epi (Arg : Optimizer) = struct
  let endpoint = "/gp/next_points/epi"

  type request =
    { num_to_sample: int
    ; mc_iterations: int
    ; max_num_threads: int
    ; gp_historical_info: gp_historical_info
    ; domain_info: bounded_domain_info
    ; covariance_info: covariance_info (* has empty default value *)
    ; optimizer_info:
        Arg.parameters optimizer_info
        (* has empty default value *)
    ; points_being_sampled: list_of_points_in_domain [@default []]
    ; mvndst_parameters: mvndst_parameters
    (* has empty default value *) }
  [@@deriving yojson]

  let create ?(num_to_sample= 1) ?(mc_iterations= 10000) ?(max_num_threads= 4)
      ?(covariance_info= default_covariance_info)
      ?(optimizer_info= default_optimizer_info) ?(points_being_sampled= [])
      ?(mvndst_parameters= default_mvndst_parameters) ~gp_historical_info
      ~domain_info () =
    { num_to_sample
    ; mc_iterations
    ; max_num_threads
    ; gp_historical_info
    ; domain_info
    ; covariance_info
    ; optimizer_info
    ; points_being_sampled
    ; mvndst_parameters }

  type response = next_points_response [@@deriving yojson]
end

module EpiNewton = Epi (struct
  type parameters = newton_parameters [@@deriving yojson]
end)

module EpiLbfgsb = Epi (struct
  type parameters = lbfgsb_parameters [@@deriving yojson]
end)

module EpiGradient = Epi (struct
  type parameters = gradient_descent_parameters [@@deriving yojson]
end)

module ConstantLiar (Arg : Optimizer) = struct
  let endpoint = "/gp/next_points/constant_liar"

  (* gp_next_points_constant_liar *)
  type lie_method =
    | CONSTANT_LIAR_MIN
    | CONSTANT_LIAR_MAX
    | CONSTANT_LIAR_MEAN
  [@@deriving yojson]

  type request =
    { num_to_sample: int [@default 1]
    ; mc_iterations: int [@default 10000]
    ; max_num_threads: int [@default 4]
    ; gp_historical_info: gp_historical_info
    ; domain_info: domain_info
    ; covariance_info: domain_info (* has empty default value *)
    ; optimizer_info:
        Arg.parameters optimizer_info
        (* has empty default value *)
    ; points_being_sampled: list_of_points_in_domain [@default []]
    ; mvndst_parameters: mvndst_parameters (* has empty default value *)
    ; lie_method: lie_method [@default CONSTANT_LIAR_MAX]
    ; lie_value: float option [@default None]
    ; lie_noise_variance: float [@default 1e-12] }
  [@@deriving yojson]

  type response = next_points_response [@@deriving yojson]
end

module ConstantLiarNewton = ConstantLiar (struct
  type parameters = newton_parameters [@@deriving yojson]
end)

module ConstantLiarLbfgsb = ConstantLiar (struct
  type parameters = lbfgsb_parameters [@@deriving yojson]
end)

module ConstantLiarGradient = ConstantLiar (struct
  type parameters = gradient_descent_parameters [@@deriving yojson]
end)

module Kriging (Arg : Optimizer) = struct
  let endpoint = "/gp/next_points/kriging"

  type request =
    { num_to_sample: int [@default 1]
    ; mc_iterations: int [@default 10000]
    ; max_num_threads: int [@default 4]
    ; gp_historical_info: gp_historical_info
    ; domain_info: domain_info
    ; covariance_info: domain_info (* has empty default value *)
    ; optimizer_info:
        Arg.parameters optimizer_info
        (* has empty default value *)
    ; points_being_sampled: list_of_points_in_domain [@default []]
    ; mvndst_parameters: mvndst_parameters (* has empty default value *)
    ; std_deviation_coeff: float [@default 0.0]
    ; kriging_noise_variance: float [@default 1e-8] }
  [@@deriving yojson]

  type response = next_points_response [@@deriving yojson]
end

module KrigingNewton = Kriging (struct
  type parameters = newton_parameters [@@deriving yojson]
end)

module KrigingLbfgsb = Kriging (struct
  type parameters = lbfgsb_parameters [@@deriving yojson]
end)

module KrigingGradient = Kriging (struct
  type parameters = gradient_descent_parameters [@@deriving yojson]
end)
