[@@@warning "-39"]

open Common

module EpiNewton : sig
  include Endpoint

  val create :
       ?num_to_sample:int
    -> ?mc_iterations:int
    -> ?max_num_threads:int
    -> ?covariance_info:covariance_info
    -> ?optimizer_info:newton_parameters optimizer_info
    -> ?points_being_sampled:list_of_points_in_domain
    -> ?mvndst_parameters:mvndst_parameters
    -> gp_historical_info:gp_historical_info
    -> domain_info:bounded_domain_info
    -> unit
    -> request
end

module EpiLbfgsb : sig
  include Endpoint

  val create :
       ?num_to_sample:int
    -> ?mc_iterations:int
    -> ?max_num_threads:int
    -> ?covariance_info:covariance_info
    -> ?optimizer_info:lbfgsb_parameters optimizer_info
    -> ?points_being_sampled:list_of_points_in_domain
    -> ?mvndst_parameters:mvndst_parameters
    -> gp_historical_info:gp_historical_info
    -> domain_info:bounded_domain_info
    -> unit
    -> request
end

module EpiGradient : sig
  include Endpoint

  val create :
       ?num_to_sample:int
    -> ?mc_iterations:int
    -> ?max_num_threads:int
    -> ?covariance_info:covariance_info
    -> ?optimizer_info:gradient_descent_parameters optimizer_info
    -> ?points_being_sampled:list_of_points_in_domain
    -> ?mvndst_parameters:mvndst_parameters
    -> gp_historical_info:gp_historical_info
    -> domain_info:bounded_domain_info
    -> unit
    -> request
end

module ConstantLiarNewton : Endpoint

module ConstantLiarLbfgsb : Endpoint

module ConstantLiarGradient : Endpoint

module KrigingNewton : Endpoint

module KrigingLbfgsb : Endpoint

module KrigingGradient : Endpoint
