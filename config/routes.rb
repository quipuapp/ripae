Rails.application.routes.draw do
  get "/auth/bancsabadell/callback" => "omniauth#bancsabadell"

  resources :bank_entries, only: :index
  resources :invoices, only: :index

  root to: 'home#index'
end
