class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
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
    @admin = current_admin
    unless @admin.email == "admin@admin.com"
      flash[:alert] = "権限がありません"
    end
  end

end
