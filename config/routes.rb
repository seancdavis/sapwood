Rails.application.routes.draw do

  match '*all' => 'api#options', :via => :options

  # ---------------------------------------- | Errors

  get '/404' => 'errors#not_found'
  get '/422' => 'errors#unacceptable'
  get '/500' => 'errors#server_error'

  # ---------------------------------------- API

  namespace :api do
    resources :properties, only: [:show] do
      resources :elements, only: [:index, :show, :create] do
        post 'webhook', on: :collection if Rails.env.development?
      end
      post 'generate_url' => 'elements#generate_url'
    end
  end

  # ---------------------------------------- Authentication

  devise_for :users

  get 'auth/:user_id/:id/:key' => 'application#auth', :as => :auth

  # ---------------------------------------- App

  get '(properties/:property_id)/profile/edit' => 'profile#edit', :as => :edit_profile
  patch '(properties/:property_id)/profile/edit' => 'profile#update', :as => :update_profile

  get 'deck' => 'deck#show', :as => :deck

  resources :properties, except: [:index, :destroy, :edit] do
    get 'setup/:step' => 'properties#edit', :as => :setup
    get 'tools/import' => 'properties#import', :as => :import
    patch 'tools/import' => 'properties#process_import', :as => :process_import
    get 'settings/:screen' => 'properties#edit', :as => :edit, :on => :member
    resources :keys, except: %i[show]
    resources :users
    get 'search' => 'elements#search', :as => 'search'

    resources :templates, only: [], path: 'elements' do
      resources :elements, path: ''
    end
    resources :templates, only: [], path: 'documents' do
      resources :documents, path: ''
    end
    resources :notifications, only: [:create]
  end

  root to: 'application#home'

end
