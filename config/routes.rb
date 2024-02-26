# typed: strict
Rails.application.routes.draw do
  get "backoffice", to: "backoffice/dashboard#index"

  namespace :backoffice do
    resources :message, only: [:create] do
      post "", action: :new, constraints: { message_id: /\d{1,}/ }, as: :new
    end

    resources :categories, except: [:show, :destroy]
    resources :members, except: [:show, :create, :new, :destroy]
    resources :users, except: [:show]
    resources :roles, except: [:show]
    resources :permissions, only: [:index]
    get "dashboard", to: "dashboard#index"
  end

  namespace :site do
    get "home", to: "home#index"
  end

  devise_for :users, skip: [:registrations]
  # devise_for :members

  get "site/home"
  root "site/home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
