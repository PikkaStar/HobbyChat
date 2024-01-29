class User::ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user, only: [:create, :new]

  # 通報を新規作成
  def new
    @report = Report.new
    @user = User.find(params[:user_id])
  end

  def create
    @user = User.find(params[:user_id])
    @report = Report.new(report_params)
    @report.reporter_id = current_user.id # 通報する人
    @report.reported_id = @user.id # 通報される人
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
      params.require(:report).permit(:reason, :url)
    end

    def guest_user
      user = current_user
      if user.email == "guest@example.com"
        flash[:alert] = "ゲストの方は行えません"
        redirect_to posts_path
      end
    end
end
