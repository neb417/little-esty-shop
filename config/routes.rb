Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants, only: [:show] do
    get '/dashboard', to: 'merchants#show', as: :dashboard
    resources :items, except: [:destroy]
    resources :invoices, only: [:index, :show]
  end
  
  resources :invoice_items, only: [:update]

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :items
    resources :invoices
    resources :merchants
  end
end
