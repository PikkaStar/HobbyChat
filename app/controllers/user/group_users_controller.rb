class User::GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user,only: [:create,:destroy]

  # グループ加入申請を許可する処理
  def create
    @group = Group.find(params[:group_id])
    # この記述は必要なのかなと思い追加しましたがエラー
    @user = User.find(params[:user_id])
    Permit.find_by(user_id: @user.id,group_id: @group.id).destroy
    # この記述は不要ということなので消しました
    #@permit = Permit.find(params[:permit_id])
    # 元々(user_id: @permit.id)と記述していた
    @group_user = GroupUser.create(user_id: @user.id,group_id: @group.id)
    flash[:notice] = "申請を許可しました"
    redirect_to request.referer
  end
  
  # グループから脱退する処理
  def destroy
    @group_user = current_user.group_users.find_by(group_id: params[:group_id])
    @group_user.destroy
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
