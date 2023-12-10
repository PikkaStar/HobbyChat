class Admin::PostsController < ApplicationController

  before_action :authenticate_admin!

  def index
    if params[:latest]
      @posts = Post.latest.page(params[:page]).per(10)
    elsif params[:old]
      @posts = Post.old.page(params[:page]).per(10)
    elsif params[:favorite_count]
      @posts = Kaminari.paginate_array(Post.favorite_count).page(params[:page]).per(10) #Post.favorite_count
    elsif params[:comment_count]
      @posts = Kaminari.paginate_array(Post.comment_count).page(params[:page]).per(10)
    else
      @posts = Post.page(params[:page]).per(10)
    end
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "削除しました"
    redirect_to admin_posts_path
  end

end
