class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :admin_user
  # include PaginationUser

  def index
    @users = paginate_users
  end

  def show
    @user = User.find(params[:id])
    @groups = @user.groups
    @report_count = Report.where(reported_id: @user.id).count
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      unless user_params[:is_active]
        sign_out @user
      end
      flash[:notice] = "更新しました"
      redirect_to admin_user_path(@user)
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  # ユーザーが投稿した一覧の表示
  def every
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  # ユーザーがいいねした投稿表示
  def favorites
    @user = User.find(params[:id])
    # Favoriteテーブルから特定のユーザーがいいねした投稿データを全て取得
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    # Post.find(favorites)で取得するデータは配列のためページネーションが使えない
    @posts = Post.where(id: favorites).page(params[:page]).per(15)
  end

  # ユーザーがフォローしたユーザー一覧
  def follows
    @user = User.find(params[:id])
    @users = @user.following_users.page(params[:page]).per(5)
  end

  # ユーザーをフォローしてくれてる人一覧
  def followers
    @user = User.find(params[:id])
    @users = @user.follower_users.page(params[:page]).per(5)
  end



  private
    def user_params
      params.require(:user).permit(:name, :introduction, :is_active, :profile_image)
    end

    def admin_user
      @admin = current_admin
      unless @admin.email == "admin@admin.com"
        flash[:alert] = "権限がありません"
      end
    end

    def paginate_users
      if params[:follows_count]
        User.follows_count(params[:page], 10)
      elsif params[:follower_count]
        User.follower_count(params[:page], 10)
      elsif params[:posts]
        User.posts(params[:page], 10)
      else
        User.page(params[:page]).per(10)
      end
    end

end
