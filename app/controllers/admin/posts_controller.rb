class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  include PaginationPost

  def index
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
    @report_count = Report.where(reported_id: @user.id).count
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "削除しました"
    redirect_to admin_posts_path
  end
end
