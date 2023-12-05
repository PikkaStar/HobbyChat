class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user,only: [:edit,:update]

  def index
    @user = current_user
    @users = User.page(params[:page]).per(5)
  end

  def every
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    redirect_to user_path(@user)
    else
       render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name,:introduction,:profile_image)
  end

  def match_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to user_path(current_user)
    end
  end

end
