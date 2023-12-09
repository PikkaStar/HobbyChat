class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_user

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "更新しました"
      redirect_to user_path
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  private

  def admin_user
    @user = current_user
    unless @user.email == "admin@admin.com"
      flash[:alert] = "権限がありません"
      redirect_to user_path(current_user)
    end
  end

end
