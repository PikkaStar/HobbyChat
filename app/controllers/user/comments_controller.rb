class User::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user,only: [:create,:destroy]

  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
    else
    @user = @post.user
    flash.now[:alert] = "コメントは1文字以上100文字以下で入力してください"
    end
  end

  def index
    @post = Post.find(params[:post_id])
    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(10)
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comments = @post.comments.page(params[:page]).per(5)
    @comment = @post.comments.find(params[:id])
    @comment.destroy
  end

  private
  def comment_params
    params.require(:comment).permit(:comment)
  end

  def guest_user
    user = current_user
    if user.email == "guest@example.com"
      flash[:alert] = "ゲストの方は行えません"
      redirect_to posts_path
    end
  end

end
