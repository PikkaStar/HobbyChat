class User::TalksController < ApplicationController
  before_action :authenticate_user!

  def create
    @area = Area.find(params[:area_id])
    if Entry.where(user_id: current_user.id,area_id: params[:talk][:area_id]).present?
      @message = Talk.create(params.require(:talk).permit(:user_id, :message, :area_id).merge(user_id: current_user.id))
    else
      flash[:alert] = "メッセージを送信できませんでした"
    end

    @talks = @area.talks.page(params[:page]).per(20)
  end


end
