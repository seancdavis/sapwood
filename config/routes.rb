Rails.application.routes.draw do

  devise_for :users

  get 'install(/:step)' => 'install#show', :as => :install
  post 'install(/:step)' => 'install#update', :as => :install_update

  get 'deck' => 'deck#show', :as => :deck

  resources :properties, :except => [:index, :destroy] do
    get 'setup/:step' => 'properties#edit', :as => :setup

    resources :elements
  end

  root :to => 'application#home'

end
