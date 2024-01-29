class User::MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user, only: [:create, :destroy]
  before_action :match_user

  # 非同期
  def create
    @message = current_user.messages.new(message_params)
    @group = Group.find(params[:group_id])
    @message.group_id = @group.id
    @message.save
    @messages = @group.messages.page(params[:page]).per(20)
  end

  # 非同期
  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    @group = Group.find(params[:group_id])
    @messages = @group.messages.page(params[:page]).per(20)
  end


  private
    def message_params
      params.require(:message).permit(:message)
    end

    def guest_user
      user = current_user
      if user.email == "guest@example.com"
        flash[:alert] = "ゲストの方は行えません"
        redirect_to user_path(current_user)
      end
    end

    def match_user
      message = Message.find(params[:id])
      message.user_id == current_user.id
      redirect_to user_path(current_user)
    end
end
