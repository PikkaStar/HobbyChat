class User::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user, only: [:edit, :update, :destroy]
  before_action :my_post, only: [:show]
 # include PaginationPost

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    # 投稿に紐づくタグ名を入力フォームから取得(空白で区切ると複数登録)
    tag_list = params[:post][:name].split(/[[:blank:]]+/).select(&:present?)
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
    @tag_list = Tag.all
    @posts = paginate_posts
  end


  def show
    @tag_list = @post.tags.pluck(:name).join(",")
    @post_tags = @post.tags
    @user = @post.user
    @comment = Comment.new
    # 最後に登録されたコメントを取得
    @comments = @post.comments.last
  end

  def edit
    @tag_list = @post.tags.pluck(:name).join(",")
  end

  def update
    tag_list = params[:post][:name].split(/[[:blank:]]+/).select(&:present?)
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
      params.require(:post).permit(:title, :body, :image)
    end

    def match_user
      @post = Post.find(params[:id])
      unless @post.user_id == current_user.id
        redirect_to user_path(current_user)
      end
    end

    def my_post
      @post = Post.find(params[:id])
    end


    def paginate_posts
      if params[:latest]
        Post.latest.page(params[:page]).per(10)
      elsif params[:old]
        Post.old.page(params[:page]).per(10)
      elsif params[:favorite_count]
        # ソートしたデータをpaginateするにはKaminari.paginate_arrayが必要
        Post.favorite_count(params[:page],10)
        # Post.favorite_count
      elsif params[:comment_count]
        Post.comment_count(params[:page],10)
      else
        Post.page(params[:page]).per(10)
      end
    end

  end