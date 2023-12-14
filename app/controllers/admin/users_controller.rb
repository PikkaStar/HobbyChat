class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :admin_user

  def index
    if params[:follows_count]
      @users = Kaminari.paginate_array(User.follows_count).page(params[:page]).per(10)
    elsif params[:follower_count]
      @users = Kaminari.paginate_array(User.follower_count).page(params[:page]).per(10)
    elsif params[:posts]
      @users = Kaminari.paginate_array(User.posts).page(params[:page]).per(10)
    else
      @users = User.page(params[:page]).per(10)
    end
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
      flash[:notice] = "更新しました"
      redirect_to admin_user_path(@user)
    else
      flash[:alert] = "更新に失敗しました"
      render :edit
    end
  end

  def every
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def favorites
    @user = User.find(params[:id])
    # Favoriteテーブルから特定のユーザーがいいねした投稿データを全て取得
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    # Post.find(favorites)で取得するデータは配列のためページネーションが使えない
    @posts = Post.where(id: favorites).page(params[:page]).per(15)
  end

  def follows
    @user = User.find(params[:id])
    @users = @user.following_users.page(params[:page]).per(5)
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.follower_users.page(params[:page]).per(5)
  end



  private

  def user_params
    params.require(:user).permit(:name,:introduction,:is_active,:profile_image)
  end

  def admin_user
    @admin = current_admin
    unless @admin.email == "admin@admin.com"
      flash[:alert] = "権限がありません"
    end
  end

end
