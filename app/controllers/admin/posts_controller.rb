class Admin::PostsController < ApplicationController
  before_action :authenticate_admin!
  # include PaginationPost

  def index
    @posts = paginate_posts
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

  private
  def paginate_posts
    if params[:favorite_count]
      Post.favorite_count(params[:page], 10)
    elsif params[:comment_count]
      Post.comment_count(params[:page], 10)
    else
      Post.page(params[:page]).per(10)
    end
  end

end
