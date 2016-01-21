class TimezonesController < ApplicationController

  before_action :authenticate_with_token!
  load_and_authorize_resource


  def index
    render json: current_user.timezones
  end


  def show
    render json: current_user.timezones.find(params[:id])
  end


  def create
    timezone = current_user.timezones.build(timezone_params)

    if timezone.save
      render json: timezone, status: 201
    else
      render json: { errors: timezone.errors }, status: 422
    end
  end


  def update
    timezone = current_user.timezones.find(params[:id])
    if timezone.update(timezone_params)
      render json: timezone, status: 200
    else
      render json: { errors: timezone.errors }, status: 422
    end
  end


  def destroy
    timezone = current_user.timezones.find(params[:id])
    timezone.destroy
    head 204
  end


  private
    def timezone_params
      params.require(:timezone).permit(:name, :abbr, :gmt_difference)
    end

end