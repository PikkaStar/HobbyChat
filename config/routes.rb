Rails.application.routes.draw do

  devise_for :admins,skip: [:registrations,:passwords],controllers: {
    sessions: "admin/sessions"
  }
  devise_for :users,skip: [:passwords],controllers: {
    registrations: "user/registrations",
    sessions: "user/sessions"
  }

  namespace :admin do
    root to: "homes#top"
    resources :users, only: [:index, :show, :edit, :update]
    resources :posts, only: [:index, :show, :edit, :destroy]
  end

  scope module: :user do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :posts do
      resource :favorite,only: [:create,:destroy]
    end
    resources :users,only: [:index,:show,:edit,:update] do
      member do
        get :favorites
      end
    end
    get "every/:id"=>"users#every",as: "every"
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
