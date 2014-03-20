Podweb::Application.routes.draw do
  root :to => "home#index"
  resources :users, :only => [ :show, :edit, :update ]
  resources :podcasts
  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', :as => :signin
  get '/signout' => 'sessions#destroy', :as => :signout
  get '/auth/failure' => 'sessions#failure'
end
