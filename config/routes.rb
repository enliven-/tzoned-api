Rails.application.routes.draw do

  
  resources  :sessions, only: [:create, :destroy]

  resources  :users do
    resources :timezones
  end

end
