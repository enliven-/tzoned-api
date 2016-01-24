class TimezonesController < ApplicationController
  before_action :set_user
  before_action :authenticate_with_token!
  authorize_resource :user
  authorize_resource :through => :user
  

  
  def index
    timezones = Timezone.load_for(current_user)

    if params[:q].present?
      render json: timezones.filter(params[:q][:term])
    else
      render json: timezones
    end
  end


  def show
    render json: Timezone.load_for(current_user).find(params[:id])
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
    timezone = Timezone.load_for(current_user).find(params[:id])
    if timezone.update(timezone_params)
      render json: timezone, status: 200
    else
      render json: { errors: timezone.errors }, status: 422
    end
  end


  def destroy
    timezone = Timezone.load_for(current_user).find(params[:id])
    timezone.destroy
    head 204
  end


  private

    def set_user
      @user = User.find(params[:user_id])
    end


    def timezone_params
      params.require(:timezone).permit(:name, :abbr, :gmt_difference)
    end

end