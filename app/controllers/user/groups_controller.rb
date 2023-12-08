class User::GroupsController < ApplicationController

  before_action :authenticate_user!
  before_action :guest_user,only: [:new,:create,:edit,:update,:destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy, :permits]

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.user_id = current_user.id
    if @group.save
      redirect_to group_path(@group)
    else
      render :new
    end
  end

  def index
    @groups = Group.page(params[:page]).per(15)
  end

  def show
    @group = Group.find(params[:id])
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    @group.update(group_params)
    redirect_to group_path(@group)
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  def members
    @group = Group.find(params[:id])
    @members = @group.users.page(params[:page]).per(15)
  end

  def permits
    @group = Group.find(params[:id])
    @permits = @group.permits.page(params[:page])
  end

  private

  def group_params
    params.require(:group).permit(:name,:introduction,:group_image)
  end

  def guest_user
    user = current_user
    if user.email == "guest@example.com"
      flash[:alert] = "ゲストの方は行えません"
      redirect_to user_path(current_user)
    end
  end

  def ensure_correct_user
    group = Group.find(params[:id])
    unless group.owner_id == current_user.id
      flash[:alert] = "グループマスターのみ編集できます"
      redirect_to group_path(group)
    end
  end

end
