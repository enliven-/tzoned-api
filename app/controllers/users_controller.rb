class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, except: [:create]
  load_and_authorize_resource


  def show
    render json: @user
  end

  def index
    users = User.all_except(current_user)
    render json: users
  end


  def create
    user = User.new(user_params)
    
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end


  def update

    if @user.update(user_params)
      render json: @user, status: 200
    else
      render json: { errors: @user.errors }, status: 422
    end
  end


  def destroy
    if @user.destroy
      head 204
    else
      render json: { errors: @user.errors }, status: 422
    end
  end

  
  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :role)
    end
end
