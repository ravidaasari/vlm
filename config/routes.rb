Rails.application.routes.draw do
  get 'decommission/index'
  get 'power_management/index'
  devise_for :users
  get 'clone_build/index'
  get 'clone_build/find_datacenters'
  get 'clone_build/find_cdn'
  get 'clone_build/create'
  get 'clone_build/find_vms'
  get 'clone_build/find_folders'
  get 'clone_build/find_vms_of_folder'
  get 'clone_build/find_resource_pool'
  get 'home/index'


  get 'power_management/index'
  get 'power_management/power'
  get 'power_management/find_datacenters'
  get 'power_management/find_folders'
  get 'power_management/find_vms'
  get 'power_management/find_vms_of_folder'

  get 'decommission/index'
  get 'decommission/decommission'
  get 'decommission/find_datacenters'
  get 'decommission/find_folders'
  get 'decommission/find_vms'
  get 'decommission/find_vms_of_folder'


  get 'standard_build/index'
  get 'standard_build/create'
  get 'standard_build/find_datacenters'
  get 'standard_build/find_clusters'
  get 'standard_build/find_datastores'
  get 'standard_build/find_networks'
  get 'standard_build/find_cdn'
  resources :catalogs
  get '/providers/disconnect' 
  resources :providers
  
  
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
