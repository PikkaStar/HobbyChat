class User::GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user,only: [:create]


def create
  @group = Group.find(params[:group_id])
  @permit = Permit.find(params[:permit_id])
  @group_user = GroupUser.create(user_id: @permit.user_id,group_id: @group.id)
  @permit.destroy
  redirect_to request.referer
end

def destroy
  group_user = current_user.group_users.find_by(group_id: params[:group_id])
  group_user.destroy
  redirect_to request.referer
end

  private

def guest_user
  user = current_user
  if user.email == "guest@example.com"
    flash[:alert] = "ゲストの方は行えません"
    redirect_to user_path(current_user)
  end
end


end
