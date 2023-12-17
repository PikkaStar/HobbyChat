class Admin::RoomsController < ApplicationController
  def show
    @group = Group.find(params[:group_id])
    @messages = @group.messages.page(params[:page]).per(20)
  end
end
