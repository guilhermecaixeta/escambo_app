# typed: strict
Rails.application.routes.draw do
  namespace :backoffice do
    resources :message, only: [:create] do
      post "", action: :new, constraints: { message_id: /\d{1,}/ }, as: :new
    end

    resources :categories, except: [:show, :destroy]
    resources :members, only: [:index, :update, :edit]
    resources :admins, except: [:show]
    resources :roles, except: [:show]
    resources :permissions, only: [:index]
    resources :dashboard, only: [:index]
  end
  get "backoffice", to: "backoffice/dashboard#index"
  get "site/profile", to: "site/profile/dashboard#index"

  namespace :site do
    resources :advertisements, only: [:show] do
      member do
        get "comments/new", controller: "comments", action: "new"
        post "comments", controller: "comments", action: "create"
      end

      collection do
        get "search"
      end
    end
    resources :categories, param: :description do
      get "advertisements"
    end
    resources :home, only: [:index]
    namespace :profile do
      resources :dashboard, only: [:index]
      resources :advertisements, except: [:show]
      resources :member_profile, only: [:show, :edit, :update]
    end
  end

  devise_for :admins, skip: [:registrations]
  devise_for :members, controllers: { sessions: "members/sessions", registrations: "members/registrations" }

  get "site/home"
  root "site/home#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
