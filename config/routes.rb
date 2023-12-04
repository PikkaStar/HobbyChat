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
  end

  scope module: :admin do
    resources :posts,only: [:index,:show,:edit,:destroy]
    resources :users,only: [:index,:show,:edit,:update]
  end

  scope module: :user do
    root to: 'homes#top'
    get 'about' => 'homes#about'
    resources :posts
    resources :users,only: [:index,:show,:edit,:update]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
