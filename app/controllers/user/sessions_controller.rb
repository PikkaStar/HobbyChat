# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
   before_action :configure_sign_in_params, only: [:create]

   def after_sign_in_path_for(resource)
       user_path(current_user)
   end

   def after_sign_out_path_for(resource)
       flash[:alert] = "ログアウトしました"
       root_path
   end

   def guest_sign_in
     user = User.guest
     sign_in user
     flash[:notice] = "ゲストでログインしました"
     redirect_to posts_path
   end

  private

   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:name,:password])
   end
end
