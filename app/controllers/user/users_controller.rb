class User::UsersController < ApplicationController

  def index
    @user = current_user
    @users = User.page(params[:page]).per(5)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user)
  end

  private

  def user_params
    params.require(:user).permit(:name,:introduction,:profile_image)
  end

end
