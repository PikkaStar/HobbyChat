class Admin::GroupsController < ApplicationController
  def index
    if params[:latest]
      @groups = Group.latest.page(params[:page]).per(15)
    elsif params[:old]
      @groups = Group.old.page(params[:page]).per(15)
    elsif params[:members]
      @groups = Kaminari.paginate_array(Group.members).page(params[:page]).per(15)
    else
      @groups = Group.page(params[:page]).per(15)
    end
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

  def members
    @group = Group.find(params[:id])
    @members = @group.users.page(params[:page]).per(15)
  end

end
