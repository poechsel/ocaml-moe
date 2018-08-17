[@@@warning "-39"]

(* This is due because of yojson ppx *)
open Common

module HyperOpt (Arg : Optimizer) = struct
  let endpoint = "/gp/hyper_opt"

  type log_likelihood_info =
    | LEAVE_ONE_OUT_LOG_LIKELIHOOD
    | LOG_MARGINAL_LIKELIHOOD
  [@@deriving yojson]

  type request =
    { max_num_threads: int [@default 4]
    ; gp_historical_info: gp_historical_info
    ; domain_info: domain_info
    ; covariance_info: covariance_info (* has empty default val *)
    ; hyperparameter_domain_info: bounded_domain_info
    ; optimizer_info: Arg.parameters optimizer_info (* has empty default val *)
    ; log_likelihood_info: log_likelihood_info
           [@default LOG_MARGINAL_LIKELIHOOD] }
  [@@deriving yojson]

  type status =
    { log_likelihood: float
    ; grad_log_likelihood: float list
    ; optimizer_success: Yojson.Safe.json
    (* doesn't really matters for now *) }
  [@@deriving yojson]

  type response =
    {endpoint: string; covariance_info: covariance_info; stats: status}
  [@@deriving yojson]
end

module HyperOptNewton = HyperOpt (struct
  type parameters = newton_parameters [@@deriving yojson]
end)

module HyperOptLbfgsb = HyperOpt (struct
  type parameters = lbfgsb_parameters [@@deriving yojson]
end)

module HyperOptGradient = HyperOpt (struct
  type parameters = gradient_descent_parameters [@@deriving yojson]
end)
