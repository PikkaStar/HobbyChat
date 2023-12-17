class Admin::MessagesController < ApplicationController
  before_action :authenticate_admin!

  def destroy
    @message = Message.find(params[:id])
    @message.destroy
    flash[:notice] = "削除に成功しました"
    redirect_to request.referer
  end

end
