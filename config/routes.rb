Rails.application.routes.draw do

  devise_for :users

  get 'auth/:user_id/:id/:key' => 'application#auth', :as => :auth

  get 'install(/:step)' => 'install#show', :as => :install
  post 'install(/:step)' => 'install#update', :as => :install_update

  get 'profile/edit' => 'profile#edit', :as => :edit_profile
  patch 'profile/edit' => 'profile#update', :as => :update_profile

  get 'deck' => 'deck#show', :as => :deck

  get 'geocoder/search' => 'geocoder#search'

  resources :properties, :except => [:index, :destroy] do
    get 'setup/:step' => 'properties#edit', :as => :setup

    resources :elements
    resources :documents
    resources :collections
    resources :users
  end

  root :to => 'application#home'

end
