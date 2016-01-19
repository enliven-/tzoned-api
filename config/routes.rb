Rails.application.routes.draw do

  devise_for :users, only: [:sign_in]
  
  resources  :sessions, only: [:create, :destroy]

  resources  :users, only: [:show, :create, :update, :destroy] do
    resources :timezones
  end

end
