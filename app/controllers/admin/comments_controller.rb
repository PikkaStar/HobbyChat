class Admin::CommentsController < ApplicationController

    before_action :authenticate_admin!

  def index
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(10)
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comments = @post.comments.page(params[:page]).per(5)
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to request.referer
  end

end
