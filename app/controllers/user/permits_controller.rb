class User::PermitsController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user,only: [:create,:destroy,:rejected]
  before_action :match_user, only: [:destroy]
  before_action :owner_user, only: [:rejected]

  # グループ参加申請を送る処理
  def create
    group = Group.find(params[:group_id])
    permit = current_user.permits.new(group_id: group.id)
    permit.save
    flash[:notice] = "参加申請をしました"
    redirect_to request.referer
  end

  # グループ参加申請を取消す処理
  def destroy
    group = Group.find(params[:group_id])
    permit = current_user.permits.find_by(group_id: group.id)
    permit.destroy
    flash[:alert] = "参加申請を取り消しました"
    redirect_to request.referer
  end
  # 参加申請を(グループマスターが)拒否する処理
  def rejected
    user = User.find(params[:user_id])
    permit = user.permits.find_by(group_id: group.id)
    permit.update(rejected: true)
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

  def match_user
    group = Group.find(params[:group_id])
    permit = Permit.find_by(group_id: group.id)
    unless permit.user_id == current_user.id
      flash[:alert] = "不正な操作です"
      redirect_to user_path(current_user)
    end
  end

  def owner_user
    group = Group.find(params[:group_id])
    unless group.owner_id == current_user.id
      flash[:alert] = "不正な操作です"
      redirect_to user_path(current_user)
    end
  end

end
