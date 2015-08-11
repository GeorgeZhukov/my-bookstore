Rails.application.routes.draw do

  devise_for :users, controllers: {
                       registrations: 'registrations',
                       omniauth_callbacks: 'users/omniauth_callbacks'
                   }

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

  resources :welcome, only: [:index]
  resources :books, only: [:index, :show] do
    resources :ratings, only: [:index, :create]
    resources :wish_list_books, only: [:create]
    member do
      put 'add-to-cart'
    end
  end
  resources :wish_list_books, only: [:index, :destroy]
  resources :authors, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :cart, only: [:show, :update] do
    member do
      delete 'remove-item'
      delete 'clear'
    end
  end
  resources :orders, only: [:index, :show]

end
