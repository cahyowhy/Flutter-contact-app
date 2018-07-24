Rails.application.routes.draw do
  resources :user_groups, :only => [:create, :destroy, :index]
  resources :groups, :except => [:show]
  resources :phone_numbers, :except => [:index, :show]
  resources :contacts, :only => [:update]
  resources :users, :except => [:show]
end
