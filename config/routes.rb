Rails.application.routes.draw do

  devise_for :users

  get 'install/:step' => 'install#run', :as => :install
  post 'install/:step/next' => 'install#next', :as => :install_next

  root :to => 'application#home'

end
