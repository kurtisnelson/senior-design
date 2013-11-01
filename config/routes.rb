Fenway::Application.routes.draw do
  resources :users

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  as :user do
    delete "/logout" => "devise/sessions#destroy"
  end

  resources :state, only: [:show, :update], defaults: { format: 'json' } do
    put 'single'
    put 'double'
    put 'triple'
    put 'ball'
    put 'steal'
    put 'strike'
    put 'next_inning'
    put 'start_game'
    put 'homerun'
    put 'score'
    put 'move'
  end

  resources :games do
  	get 'score'
    post 'score'
  end

  resources :teams do
    get 'autocomplete_user_name', :on => :collection
    resources :players do
      put 'update_jersey_number'
      put 'destroy'
    end
  end

  root to: 'home#index'
end
