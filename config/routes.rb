Rails.application.routes.draw do
  resources :webhooks
  resources :customers
  resources :documents
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
