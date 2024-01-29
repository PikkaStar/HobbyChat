class User::NotificationsController < ApplicationController
  def index
    # ログインユーザーに関連付けられたすべての通知を新しい順で取得
    @notifications = current_user.notifications.order(created_at: :desc).page(params[:page]).per(20)
    # 全ての通知から(checked: false)のものを取り出す
    @notifications.where(checked: false).each do |notification|
      # 通知を確認済みにする
      notification.update(checked: true)
    end
  end

  def destroy
    # 全ての通知を削除
    @notifications = current_user.notifications.destroy_all
    redirect_to notifications_path
  end
end
