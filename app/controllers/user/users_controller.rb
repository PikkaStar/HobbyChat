class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user,only: [:edit,:update]
  before_action :guest_user,only: [:edit,:update,:cancellation]

  # ソートで表示するための処理
  def index
    @user = current_user
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

  # ユーザーが投稿した一覧
  def every
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.area_id == u.area_id
            @isArea = true
            @areaId = cu.area_id
          end
        end
      end
      unless @isArea
        @area = Area.new
        @entry = Entry.new
      end
    end
    @posts = @user.posts.page(params[:page]).per(10)
    @groups = @user.groups
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
    redirect_to user_path(@user)
    else
       render :edit
    end
  end

  def favorites
    @user = User.find(params[:id])
    # Favoriteテーブルから特定のユーザーがいいねした投稿データを全て取得
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    # Post.find(favorites)で取得するデータは配列のためページネーションが使えない
    @posts = Post.where(id: favorites).page(params[:page]).per(15)
  end

  # 退会処理
  def cancellation
    @user = current_user
    @user.update(is_active: false)
    reset_session
    flash[:alert] = "退会しました"
    redirect_to root_path
  end

  # フォロー一覧
  def follows
    @user = User.find(params[:id])
    @users = @user.following_users.page(params[:page]).per(5)
  end

  # フォロワー一覧
  def followers
    @user = User.find(params[:id])
    @users = @user.follower_users.page(params[:page]).per(5)
  end

  private

  def user_params
    params.require(:user).permit(:name,:introduction,:profile_image)
  end

  def match_user
    user = User.find(params[:id])
    unless user == current_user
      redirect_to user_path(current_user)
    end
  end

  def guest_user
    user = current_user
    if user.email == "guest@example.com"
      flash[:alert] = "ゲストの方は行えません"
      redirect_to user_path(current_user)
    end
  end

end
