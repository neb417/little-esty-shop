Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants, only:[] do
    scope module: :merchants do
      get '/dashboard', to: 'dashboard#show', as: :dashboard
      resources :items, except: [:destroy]
      resources :invoices, only: [:index, :show]
    end
  end

  resources :invoice_items, only: [:update]

  namespace :admin do
    get '/', to: 'dashboard#index'
    resources :invoices, only: [:index, :show]
    resources :merchants, except: [:destroy]
  end
end
