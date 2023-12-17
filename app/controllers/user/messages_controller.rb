class User::MessagesController < ApplicationController
   before_action :authenticate_user!
   before_action :guest_user,only: [:create,:destroy]

   def create
     @message = current_user.messages.new(message_params)
     @group = Group.find(params[:group_id])
     @message.group_id = @group.id
     @message.save
     redirect_to request.referer
   end

   def destroy

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
