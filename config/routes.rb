Myflix::Application.routes.draw do
  root to: "pages#front"
  get '/register', to: 'users#new'
  resources :users, only: [:show, :create]
  resources :relationships, only: [:create, :destroy]
  get '/people', to: 'relationships#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  resources :categories, only: [:show]
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  get 'ui(/:action)', controller: 'ui' do
    collection
  end
  get 'my_queue', to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy]
  post '/update_queue', to: 'queue_items#update_queue'
  get '/lost_password', to: 'passwords#new'
  resources :passwords, only: [:create]
  get '/password_confirmation', to: 'passwords#confirm'
  resources :reset_passwords, only: [:show, :create]
  get '/expired_token', to: 'reset_passwords#expired_token'
  resources :invitations, only: [:new, :create]
  get '/register/:token', to: 'users#new_invitation_with_token', as: 'register_with_token'

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  mount StripeEvent::Engine => '/stripe_events'
end
