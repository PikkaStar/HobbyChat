class User::AreasController < ApplicationController
  before_action :authenticate_user!

  def create
    @area = Area.create(user_id: current_user.id)
    @entry1 = Entry.create(area_id: @area.id, user_id: current_user.id)
    @entry2 = Entry.create(params.require(:entry).permit(:user_id, :area_id).merge(area_id: @area.id))
    redirect_to area_path(@area.id)
  end

  def show
    @area = Area.find(params[:id])
    if Entry.where(user_id: current_user.id, area_id: @area.id).present?
      @talk = Talk.new
      @talks = @area.talks.page(params[:page]).per(20)
      @entries = @area.entries
    else
      redirect_to user_path(current_user)
    end
  end
end
