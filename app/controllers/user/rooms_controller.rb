class User::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user, only: [:show]
  before_action :group_member

  def show
    @message = Message.new
    @group = Group.find(params[:group_id])
    @messages = @group.messages.page(params[:page]).per(20)
    #   @messages = Message.where(gropu_id: params[:group_id])
  end

  private
    def guest_user
      user = current_user
      if user.email == "guest@example.com"
        flash[:alert] = "ゲストの方は行えません"
        redirect_to user_path(current_user)
      end
    end

    def group_member
      group = Group.find(params[:group_id])
      members = group.users
      unless members.include?(current_user)
        flash[:alert] = "グループに参加していません"
        redirect_to user_path(current_user)
      end
    end
end
