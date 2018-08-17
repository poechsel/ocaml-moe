[@@@warning "-39"]

open Common

include Common.Endpoint

val create :
     ?points_being_sampled:list_of_points_in_domain
  -> ?mc_iterations:int
  -> ?max_num_threads:int
  -> ?covariance_info:covariance_info
  -> points_to_evaluate:list_of_points_in_domain
  -> gp_historical_info:gp_historical_info
  -> domain_info:domain_info
  -> request
