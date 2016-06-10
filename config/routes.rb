Rails.application.routes.draw do

  # ---------------------------------------- API

  namespace :api do
    namespace :v1 do
      resources :properties, :only => [:show]
      resources :elements, :only => [:index, :show]
      resources :collections, :only => [:show]
    end
  end

  # ---------------------------------------- Authentication

  devise_for :users

  get 'auth/:user_id/:id/:key' => 'application#auth', :as => :auth

  # ---------------------------------------- App

  get 'profile/edit' => 'profile#edit', :as => :edit_profile
  patch 'profile/edit' => 'profile#update', :as => :update_profile

  get 'deck' => 'deck#show', :as => :deck

  get 'geocoder/search' => 'geocoder#search'

  resources :properties, :except => [:index, :destroy] do
    get 'setup/:step' => 'properties#edit', :as => :setup
    get 'import' => 'properties#import', :as => :import
    patch 'import' => 'properties#process_import', :as => :process_import

    resources :elements
    resources :folders
    resources :documents
    resources :collections
    resources :users
  end

  root :to => 'application#home'

end
