class User::MessagesController < ApplicationController
   before_action :authenticate_user!
   before_action :guest_user,only: [:create,:destroy]

   def create
     @message = current_user.messages.new(message_params)
     @group = Group.find(params[:group_id])
     @message.group_id = @group.id
     @message.save
     @messages = @group.messages.page(params[:page]).per(20)
   end

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

end
