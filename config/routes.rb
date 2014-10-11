Rails.application.routes.draw do
  get "/auth/bancsabadell/callback" => "omniauth#bancsabadell"

  resources :bank_entries, only: :index do
    get :sync_with_api, on: :collection
  end
  resources :invoices, only: :index

  get "/importing" => 'home#importing'
  root to: 'home#index'
end
