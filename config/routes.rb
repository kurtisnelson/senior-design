Fenway::Application.routes.draw do
  resources :teams
  resources :athletes

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  root to: 'home#index'

  resources :games

  resources :teams
end
