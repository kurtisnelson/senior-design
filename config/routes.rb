Fenway::Application.routes.draw do
  resources :users

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  as :user do
    delete "/logout" => "devise/sessions#destroy"
  end

  resources :state, only: [:show], defaults: { format: 'json' } do
    put 'single'
    put 'double'
    put 'triple'
    put 'ball'
    put 'steal'
    put 'strike'
  end

  resources :games do
  	get 'score'
    post 'score'
  end

  resources :teams do
    put 'add_player'
  end

  root to: 'home#index'
end
