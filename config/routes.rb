Rails.application.routes.draw do

  root 'home#index'
  match 'bancs', to: 'bank_entries#index', via: [:get]
  match 'invoices', to: 'invoices#index', via: [:get]
end
