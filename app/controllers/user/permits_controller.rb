class User::PermitsController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user,only: [:create,:destroy]

def create
  @group = Group.find(params[:group_id])
  permit = current_user.permits.new(group_id: @group.id)
  permit.save
  flash[:notice] = "参加申請をしました"
  redirect_to request.referer
end

def destroy
  group = Group.find(params[:group_id])
  permit = current_user.permits.find_by(group_id: group.id)
  permit.destroy
  flash[:alert] = "参加申請を取り消しました"
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
