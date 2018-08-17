open Common

type gp_mean_var_request

type create =
     ?covariance_info:covariance_info
  -> points_to_evaluate:list_of_points_in_domain
  -> gp_historical_info:gp_historical_info
  -> domain_info:domain_info
  -> gp_mean_var_request

module GpMeanVar : sig
  include Endpoint

  val create : create
end

module GpMeanVarDiag : sig
  include Endpoint

  val create : create
end

module GpMean : sig
  include Endpoint

  val create : create
end

module GpVar : sig
  include Endpoint

  val create : create
end

module GpVarDiag : sig
  include Endpoint

  val create : create
end
