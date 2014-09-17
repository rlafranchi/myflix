Myflix::Application.routes.draw do
  root to: "pages#front"
  get '/register', to: 'users#new'
  resources :users, only: [:create, :edit, :update]
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'
  resources :videos, only: [:index, :show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  get 'ui(/:action)', controller: 'ui' do
    collection
  end
end
