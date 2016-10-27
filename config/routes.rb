Rails.application.routes.draw do

  match '*all' => 'api#options', :via => :options

  # ---------------------------------------- API

  namespace :api do
    namespace :v1 do
      resources :properties, :only => [:show] do
        resources :elements, :only => [:index, :show, :create] do
          post 'webhook', :on => :collection if Rails.env.development?
        end
        resources :collections, :only => [:index, :show]
      end
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
    resources :users
    get 'search' => 'elements#search', :as => 'search'

    resources :templates, :only => [], :path => 'elements' do
      resources :elements, :path => ''
    end
    resources :templates, :only => [], :path => 'documents' do
      resources :documents, :path => ''
    end
    resources :notifications, :only => [:create]
  end

  root :to => 'application#home'

end
