Rails.application.routes.draw do

  devise_for :admins,skip: [:registrations,:passwords],controllers: {
    sessions: "admin/sessions"
  }
  devise_for :users,skip: [:passwords],controllers: {
    registrations: "user/registrations",
    sessions: "user/sessions"
  }

  devise_scope :user do
    post "users/guest_sign_in",to: "user/sessions#guest_sign_in"
  end

  namespace :admin do
    root to: "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :destroy]
    resources :groups,only: [:index,:show,:destroy]
  end

  scope module: :user do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :posts do
      resource :favorite,only: [:create,:destroy]
      resources :comments,only: [:create,:index,:destroy]
    end
    resources :users,only: [:index,:show,:edit,:update] do
      member do
        get :follows, :followers
        get :favorites
      end
      resource :relationships, only: [:create, :destroy]
      collection do
        patch :cancellation
      end
    end
    get "check"=>"users#check",as: "check"
    get "every/:id"=>"users#every",as: "every"
    resources :groups do
      resources :group_users,only: [:create,:destroy]
      resources :permits,only: [:create,:destroy]
    end
    get "groups/:id/permits"=>"groups#permits",as: "permits"
    get "members/:id"=>"groups#members",as: "members"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
