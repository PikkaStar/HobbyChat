# frozen_string_literal: true

class User::SessionsController < Devise::SessionsController
   before_action :configure_sign_in_params, only: [:create]
   before_action :user_status,only: [:create]

   def after_sign_in_path_for(resource)
       user_path(resource)
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

  def user_status
      user = User.find_by(name: params[:user][:name])
      return if user.nil?
      return unless user.valid_password?(params[:user][:password])
      unless user.is_active == true
          flash[:alert] = "すでに退会済みです"
          redirect_to new_user_registration_path
      end
  end

   def configure_sign_in_params
     devise_parameter_sanitizer.permit(:sign_in, keys: [:name,:password])
   end
end
