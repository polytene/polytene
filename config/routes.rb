Rails.application.routes.draw do
  get 'pages/index'
  get 'pages/help'

  mount RailsAdmin::Engine => '/dashboard', as: 'rails_admin'

  devise_for :users
  devise_scope :user do
    get '/login' => 'devise/sessions#new'
    get '/logout' => 'devise/sessions#destroy'
  end

  mount Polytene::API => '/'

  root :to => 'pages#index'
end
