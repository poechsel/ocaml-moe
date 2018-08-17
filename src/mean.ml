[@@@warning "-39"]
open Common


type gp_mean_var_request = {
  points_to_evaluate : list_of_points_in_domain;
  gp_historical_info : gp_historical_info;
  domain_info : domain_info;
  covariance_info : covariance_info (* has empty default val *);
}
[@@deriving yojson]


let create
      ?(covariance_info = default_covariance_info)
      ~points_to_evaluate
      ~gp_historical_info
      ~domain_info =
    {
      points_to_evaluate;
      gp_historical_info;
      domain_info;
      covariance_info;
    }

module GpMeanVar  = struct
  let endpoint = "/gp/mean_var"

  type response = {
    endpoint : string;
    mean : float list;
    var : matrix_of_floats;
  }
  [@@deriving yojson]
  type request = gp_mean_var_request

  let create = create
end

module GpMeanVarDiag  = struct
  let endpoint = "/gp/mean_var_diag"
  type response = {
    endpoint : string;
    mean : float list;
    var : float list;
  }
  [@@deriving yojson]

  type request = gp_mean_var_request

  let create = create
end

module GpMean  = struct
  let endpoint = "/gp/mean"

  type response = {
    endpoint : string;
    mean : float list;
  }
  [@@deriving yojson]

  type request = gp_mean_var_request

  let create = create
end

module GpVar  = struct
  let endpoint = "/gp/var"

  type response = {
    endpoint : string;
    var : matrix_of_floats;
  }
  [@@deriving yojson]

  type request = gp_mean_var_request

  let create = create
end


module GpVarDiag  = struct
  let endpoint = "/gp/var_diag"


  type response = {
    endpoint : string;
    var : float list;
  }
  [@@deriving yojson]

  type request = gp_mean_var_request

  let create = create
end
