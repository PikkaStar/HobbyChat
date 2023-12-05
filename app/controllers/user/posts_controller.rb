class User::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user,only: [:edit,:update]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
       flash[:notice] = "投稿しました"
       redirect_to post_path(@post)
    else
    flash.now[:alert] = "投稿に失敗しました"
    render :new
    end
  end

  def index
    @posts = Post.page(params[:page]).per(10)
  end

  def show
    @post = Post.find(params[:id])
    @user = @post.user
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
       flash[:notice] = "更新しました"
       redirect_to post_path(@post)
    else
       flash.now[:alert] = "更新に失敗しました"
       render :edit
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "削除しました"
    redirect_to user_path(current_user)
  end

  private

  def post_params
    params.require(:post).permit(:title,:body,:image)
  end

  def match_user
    post = Post.find(params[:id])
    unless post.user_id == current_user.id
      redirect_to user_path(current_user)
    end
  end

end
