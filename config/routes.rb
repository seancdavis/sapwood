Rails.application.routes.draw do

  devise_for :users

  get 'install(/:step)' => 'install#show', :as => :install
  post 'install(/:step)' => 'install#update', :as => :install_update

  get 'deck' => 'deck#show', :as => :deck

  root :to => 'application#home'

end
