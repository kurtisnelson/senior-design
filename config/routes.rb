Fenway::Application.routes.draw do

  resources :users
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  as :user do
    delete "/logout" => "devise/sessions#destroy"
  end
  
  resources :games do
  	get 'score'
    post 'score'
  end

  resources :teams
  root to: 'home#index'
end
