class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
  include PaginationGroup

  def index
  end

  def show
    @group = Group.find(params[:id])
    @genre_list = @group.genres.pluck(:genre_name).join(",")
    @group_genres = @group.genres
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = "グループを削除しました"
    redirect_to admin_groups_path
  end

  # グループ加入者一覧表示
  def members
    @group = Group.find(params[:id])
    @members = @group.users.page(params[:page]).per(15)
  end
end
