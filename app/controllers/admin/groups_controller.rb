class Admin::GroupsController < ApplicationController
  def index
    @groups = Group.page(params[:page]).per(10)
  end

  def show
    @group = Group.find(params[:id])
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = "グループを削除しました"
    redirect_to admin_groups_path
  end
end
