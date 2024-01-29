Rails.application.routes.draw do
    devise_for :admins, skip: [:registrations, :passwords], controllers: {
      sessions: "admin/sessions"
    }
    devise_for :users, skip: [:passwords], controllers: {
      registrations: "user/registrations",
      sessions: "user/sessions"
    }

    devise_scope :user do
      post "users/guest_sign_in", to: "user/sessions#guest_sign_in"
    end

    namespace :admin do
      root to: "homes#top"
      resources :reports, only: [:index, :show, :update]
      resources :users, only: [:index, :show, :edit, :update] do
        member do
           get :follows, :followers
           get :favorites
         end
      end
      resources :posts, only: [:index, :show, :destroy] do
        resources :comments, only: [:index, :destroy]
      end
      resources :groups, only: [:index, :show, :destroy] do
        resource :rooms, only: [:show]
        resources :messages, only: [:destroy]
      end
      get "members/:id" => "groups#members", as: "members"
      get "every/:id" => "users#every", as: "every"
      get "search" => "searches#search", as: "search"
    end

    scope module: :user do
      root to: "homes#top"
      get "about" => "homes#about"
      resources :posts do
        resource :favorite, only: [:create, :destroy]
        resources :comments, only: [:create, :index, :destroy]
      end
      resources :users, only: [:index, :show, :edit, :update] do
        member do
          get :follows, :followers
          get :favorites
        end
        resource :relationships, only: [:create, :destroy]
        resources :reports, only: [:new, :create]
        # 退会
        collection do
          patch :cancellation
        end
      end
      get "check" => "users#check", as: "check"
      get "every/:id" => "users#every", as: "every"
      resources :groups do
        resources :group_users, only: [:create, :destroy]
        resource :rooms, only: [:show]
        resources :messages, only: [:create, :destroy]
        resources :permits, only: [:create, :destroy] do
          collection do
            # グループ加入真偽の更新
            patch :rejected
          end
        end
      end
      # グループ参加申請
      get "groups/:id/permits" => "groups#permits", as: "permits"
      get "members/:id" => "groups#members", as: "members"
      # 検索
      get "search" => "searches#search", as: "search"
      # タグやジャンル
      get "search_tag" => "posts#search_tag"
      get "search_genre" => "groups#search_genre"
      # 通知
      resources :notifications, only: [:index, :destroy]
      # DM機能
      resources :areas, only: [:create, :show] do
        resources :talks, only: [:create]
      end
    end


    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  end
