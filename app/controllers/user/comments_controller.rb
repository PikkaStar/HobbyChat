class User::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user,only: [:create,:destroy]

  def create
    # 非同期
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      # コメント送信後、コメントが表示されなくなったので↓の記述を追加
    @comments = @post.comments.page(params[:page]).per(10)
    else
    @user = @post.user
    flash.now[:alert] = "コメントは1文字以上100文字以下で入力してください"
    end
  end

  # 投稿に紐づいたコメント一覧
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
    # 非同期
    @post = Post.find(params[:post_id])
    # コメント削除後の表示
    @comments = @post.comments.page(params[:page]).per(10)
    # 投稿に紐づいたコメントの中から特定のコメントを取得
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
