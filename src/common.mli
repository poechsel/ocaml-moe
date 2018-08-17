[@@@warning "-39"]

module type Endpoint = sig
  type response

  type request

  val response_of_yojson : Yojson.Safe.json -> (response, string) Result.result

  val request_to_yojson : request -> Yojson.Safe.json

  val request_of_yojson : Yojson.Safe.json -> (request, string) Result.result

  val response_to_yojson : response -> Yojson.Safe.json

  val endpoint : string
end

type point = float list [@@deriving yojson]

type single_point = {point: point; value: float; value_var: float}
[@@deriving yojson]

type point_sampled = {point_sampled: single_point} [@@deriving yojson]

type points_sampled = point_sampled list [@@deriving yojson]

type domain_coordinate = {min: float; max: float} [@@deriving yojson]

type domain = {domain_coordinates: domain_coordinate list} [@@deriving yojson]

type domain_type =
  | TENSOR_PRODUCT_DOMAIN_TYPE
  | SIMPLEX_INTERSECT_TENSOR_PRODUCT_DOMAIN_TYPE
[@@deriving yojson]

type domain_info =
  {domain_type: (domain_type[@default TENSOR_PRODUCT_DOMAIN_TYPE]); dim: int}
[@@deriving yojson]

type bounded_domain_info =
  { domain_type: (domain_type[@default TENSOR_PRODUCT_DOMAIN_TYPE])
  ; dim: int
  ; domain_bounds: domain_coordinate list }
[@@deriving yojson]

type mvndst_parameters = {releps: float; abseps: float; maxpts_per_dim: int}
[@@deriving yojson]

val default_mvndst_parameters : mvndst_parameters

type covariance_type =
  | SQUARE_EXPONENTIAL_COVARIANCE_TYPE [@name "square_exponential"]
[@@deriving yojson]

val square_exponential_covariance_type : string

type covariance_info =
  {covariance_type: string (*covariance_type*); hyperparameters: float list}
[@@deriving yojson]

val default_covariance_info : covariance_info

type gp_historical_info = {points_sampled: points_sampled list}
[@@deriving yojson]

type list_of_points_in_domain_item = {points_in_domain: point}
[@@deriving yojson]

type list_of_points_in_domain = list_of_points_in_domain_item list
[@@deriving yojson]

type list_of_expected_improvements_item = {expected_improvements: float}
[@@deriving yojson]

type list_of_expected_improvements = list_of_expected_improvements_item list
[@@deriving yojson]

type matrix_of_floats_item = {row_of_matrix: float list} [@@deriving yojson]

type matrix_of_floats = matrix_of_floats_item list [@@deriving yojson]

type optimizer_type =
  | NEWTON_OPTIMIZER
  | GRADIENT_DESCENT_OPTIMIZER
  | L_BFGS_B_OPTIMIZER
[@@deriving yojson]

module type Optimizer = sig
  type parameters [@@deriving yojson]
end

type gradient_descent_parameters =
  { max_num_steps: int
  ; max_num_restarts: int
  ; num_steps_averaged: int
  ; gamma: float
  ; pre_mult: float
  ; max_relative_change: float
  ; tolerance: float }
[@@deriving yojson]

type lbfgsb_parameters =
  { approx_grad: bool
  ; max_func_evals: int
  ; max_metric_correc: int
  ; factr: float
  ; pgtol: float
  ; epsilon: float }
[@@deriving yojson]

type newton_parameters =
  { max_num_steps: int
  ; gamma: float
  ; time_factor: float
  ; max_relative_change: float
  ; tolerance: float }
[@@deriving yojson]

type 'a optimizer_info =
  { optimizer_type: optimizer_type option
  ; num_multistarts: int option
  ; num_random_samples: int option
  ; optimizer_parameters: 'a option }
[@@deriving yojson]

val default_optimizer_info : 'a optimizer_info
