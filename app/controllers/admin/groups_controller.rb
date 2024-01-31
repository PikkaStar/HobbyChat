class Admin::GroupsController < ApplicationController
  before_action :authenticate_admin!
  # include PaginationGroup

  def index
    @groups = paginate_groups
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

  private
  def paginate_groups
    if params[:latest]
      Group.latest.page(params[:page]).per(15)
    elsif params[:old]
      Group.old.page(params[:page]).per(15)
    elsif params[:members]
      Kaminari.paginate_array(Group.members).page(params[:page]).per(15)
    else
      Group.page(params[:page]).per(15)
    end
  end

end
