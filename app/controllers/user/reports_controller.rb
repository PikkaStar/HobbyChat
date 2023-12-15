class User::ReportsController < ApplicationController

  before_action :authenticate_user!
  
  # 通報を新規作成
  def new
    @report = Report.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @report = Report.new(report_params)
    @report.reporter_id = current_user.id #通報する人
    @report.reported_id = @user.id #通報される人
    if @report.save
      flash[:notice] = "通報しました。ご報告ありがとうございます。"
      redirect_to user_path(@user)
    else
      flash[:alert] = "通報に失敗しました"
      render :new
    end
  end

  private

  def report_params
    params.require(:report).permit(:reason,:url)
  end


end
