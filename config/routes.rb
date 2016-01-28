Rails.application.routes.draw do

  devise_for :users

  get 'install/:step' => 'install#run', :as => :install

  root :to => 'application#home'

end
