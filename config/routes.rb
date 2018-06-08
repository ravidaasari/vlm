Rails.application.routes.draw do
  get 'standard_build/index'
  get 'standard_build/create'
  get 'standard_build/find_datacenters'
  get 'standard_build/find_clusters'
  get 'standard_build/find_datastores'
  get 'standard_build/find_networks'
  get 'standard_build/find_cdn'
  resources :catalogs
  resources :providers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
