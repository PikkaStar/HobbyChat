class User::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user,only: [:edit,:update]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # タグを新規登録
    tag_list = params[:post][:name].split(',')
    if @post.save
       @post.save_tags(tag_list)
       flash[:notice] = "投稿しました"
       redirect_to post_path(@post)
    else
    flash.now[:alert] = "投稿に失敗しました"
    render :new
    end
  end

  # ソートでの表示処理
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
      @tag_list = Tag.all
  end


  def show
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
    @post_tags = @post.tags
    @user = @post.user
    @comment = Comment.new
    # 最後に登録されたコメントを取得
    @comments = @post.comments.last
  end

  def edit
    @post = Post.find(params[:id])
    @tag_list = @post.tags.pluck(:name).join(',')
  end

  def update
    @post = Post.find(params[:id])
    tag_list = params[:post][:name].split(',')
    if @post.update(post_params)
       @post.save_tags(tag_list)
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

  # 存在するタグを表示し、クリックするとそのタグが付いた投稿一覧が表示される
  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @posts = @tag.posts
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
