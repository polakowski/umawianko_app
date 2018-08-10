Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', as: :sign_in
  get '/signout' => 'sessions#destroy', as: :sign_out
  get '/auth/failure' => 'sessions#failure'

  root to: 'home#index'
end