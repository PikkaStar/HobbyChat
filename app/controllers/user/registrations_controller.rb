# frozen_string_literal: true

class User::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def after_sign_up_path_for(resource)
    user_path(current_user)
  end

   private
     def configure_sign_up_params
       devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email])
     end
end
