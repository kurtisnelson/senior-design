Fenway::Application.routes.draw do
  resources :games do
  	get 'score'
    post 'score'
  end

  resources :teams
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }
  root to: 'home#index'
end
