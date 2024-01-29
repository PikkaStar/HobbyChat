class User::GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user
  before_action :match_user, only: [:destroy]
  before_action :owner_user, only: [:create]

  # グループ加入申請を許可する処理
  def create
    @group = Group.find(params[:group_id])
    @user = User.find(params[:user_id])
    # 参加申請者(Permit)一覧から特定の申請者を削除
    Permit.find_by(user_id: @user.id, group_id: @group.id).destroy
    # グループ所属者(GroupUser)に申請者を追加
    @group_user = GroupUser.create(user_id: @user.id, group_id: @group.id)
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

      def owner_user
        group = Group.find(params[:group_id])
        unless group.owner_id == current_user.id
          user_path(current_user)
        end
      end

      def match_user
        user = User.find(params[:id])
        group_user = GroupUser.find_by(user_id: user.id)
        unless group_user == current_user
          user_path(current_user)
        end
      end
end
