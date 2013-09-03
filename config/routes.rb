Fenway::Application.routes.draw do
  resources :athletes

  devise_for :users
  root to: 'home#index'

  resources :games
end
