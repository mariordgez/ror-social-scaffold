Rails
  .application
  .routes
  .draw do
    get 'friendships/create', to: 'friendships#create', as: 'add_friend'
    get 'friendships/destroy'
    get 'friendships/update'
    root 'posts#index'

    devise_for :users

    resources :users, only: %i[index show]

    resources :posts, only: %i[index create] do
      resources :comments, only: [:create]
      resources :likes, only: %i[create destroy]
    end

    # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  end
