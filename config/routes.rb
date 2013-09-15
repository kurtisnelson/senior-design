Fenway::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  resources :games do
  	get 'score'
    post 'score'
  end

  resources :teams
  root to: 'home#index'
end
