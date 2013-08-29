Fenway::Application.routes.draw do
  root to: 'home#index'

  resources :games
end
