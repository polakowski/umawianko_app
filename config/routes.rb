Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/auth/:provider/callback' => 'sessions#create'
  get '/signin' => 'sessions#new', as: :sign_in
  get '/signout' => 'sessions#destroy', as: :sign_out
  get '/auth/failure' => 'sessions#failure'

  post 'slack_action', to: 'slack_actions#handle'

  resources :events, only: %i[index new create show edit update destroy] do
    resources :event_users, only: %i[new create edit update destroy]
  end

  resources :past_events, only: %i[index]

  root to: 'home#index'
end
