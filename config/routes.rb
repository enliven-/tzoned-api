Rails.application.routes.draw do

  
  resources  :sessions, only: [:create, :destroy]

  resources  :users, only: [:show, :create, :update, :destroy] do
    resources :timezones
  end

end
