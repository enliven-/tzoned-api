class ApplicationController < ActionController::API
  include ActionController::Serialization
  include Authenticable
  include CanCan::ControllerAdditions

  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: "Not Authorized" }, status: 403
  end
end
