class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user, only: [:edit, :update]
  before_action :guest_user, only: [:edit, :update, :cancellation]
  before_action :my_user, only: [:show, :every, :favorites, :follows, :followers]
  before_action :area_check, only: [:show]

 # include PaginationUser

  # ソートで表示するための処理
  def index
    @users = paginate_users
  end

  # ユーザーが投稿した一覧
  def every
    @posts = @user.posts.page(params[:page]).per(10)
  end

  def show
    @posts = @user.posts.page(params[:page]).per(10)
    @groups = @user.groups
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  def favorites
    # Favoriteテーブルから特定のユーザーがいいねした投稿データを全て取得
    favorites = Favorite.where(user_id: @user.id).pluck(:post_id)
    # Post.find(favorites)で取得するデータは配列のためページネーションが使えない
    # Postからidがfavoretesに含まれる値を取得
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
    @users = @user.following_users.page(params[:page]).per(5)
  end

  # フォロワー一覧
  def followers
    @users = @user.follower_users.page(params[:page]).per(5)
  end

  private
    def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def match_user
      @user = User.find(params[:id])
      unless @user == current_user
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

    def my_user
      @user = User.find(params[:id])
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

    def area_check
      # 自分と相手のuser_id取得
      @current_entry = Entry.where(user_id:  current_user.id)
      @partner_entry = Entry.where(user_id:  @user.id )
      unless  @user  ==  current_user
      # 自分と相手の共通するarea_idが存在するか判定
      	@current_entry.each  do  |c|
      		@partner_entry.each  do  |p|
        		if  c.area_id  ==  p.area_id
        			@isArea  =  true
        			@room  =  c.area_id
        		end
        	end
      	end
      	unless  @isArea
      		@area  =  Area.new
      		@entry  =  Entry.new
      	end
      end
    end

end
