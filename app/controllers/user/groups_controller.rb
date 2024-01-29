class User::GroupsController < ApplicationController

  before_action :authenticate_user!
  before_action :guest_user,only: [:new,:create,:edit,:update,:destroy]
  before_action :owner_user, only: [:edit, :update, :destroy, :permits]

  def new
    @group = Group.new
  end

  # グループを新規作成
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.user_id = current_user.id
    # グループ作成時、作成者をグループに加入させる処理を記述
    # 配列の末尾に追加
    @group.users << current_user
    # genre名登録
    genre_list = params[:group][:genre_name].split(',')
    if @group.save
      @group.save_genres(genre_list)
      flash.now[:notice] = "グループを作成しました"
      redirect_to group_path(@group)
    else
      flash.now[:alert] = "新規登録に失敗しました"
      render :new
    end
  end

  def index
    # ソートで表示するための記述
    if params[:latest]
      @groups = Group.latest.page(params[:page]).per(15)
    elsif params[:old]
      @groups = Group.old.page(params[:page]).per(15)
    elsif params[:members]
      @groups = Kaminari.paginate_array(Group.members).page(params[:page]).per(15)
    else
      @groups = Group.page(params[:page]).per(15)
    end
    @genre_list = Genre.all
  end

  def show
    @group = Group.find(params[:id])
    @genre_list = @group.genres.pluck(:genre_name).join(',')
    @group_genres = @group.genres
    @pending_permits_count = @group.permits.where(rejected: false).count
  end

  def edit
    @group = Group.find(params[:id])
    @group_genre = @group.genres.pluck(:genre_name).join(',')
  end

  def update
    @group = Group.find(params[:id])
    group_list = params[:group][:genre_name].split(',')
    if @group.update(group_params)
       @group.save_genres(group_list)
       redirect_to group_path(@group)
    else
      render :edit
    end
  end

  # 存在するジャンルを全表示し、クリックするとそのジャンルがついたグループ一覧が表示される
  def search_genre
    @genre_list = Genre.all
    @genre = Genre.find(params[:genre_id])
    @groups = @genre.groups
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    flash[:notice] = "グループを削除しました"
    redirect_to groups_path
  end

  # グループに所属してるユーザー一覧
  def members
    @group = Group.find(params[:id])
    @members = @group.users.page(params[:page]).per(15)
  end

  # 承認待ち画面でrefectedの値がfalse(承認待ち)のユーザーを一覧表示
  def permits
    @group = Group.find(params[:id])
    @users = @group.permited_users.includes(:permits).where(permits: {rejected: false}).page(params[:page])
   # Post.includes(:user).where(users: {gender: "man"})
  end

  private

  def group_params
    params.require(:group).permit(:name,:introduction,:group_image)
  end

  def guest_user
    user = current_user
    if user.email == "guest@example.com"
      flash[:alert] = "ゲストの方は行えません"
      redirect_to user_path(current_user)
    end
  end

  def owner_user
    group = Group.find(params[:id])
    unless group.owner_id == current_user.id
      flash[:alert] = "グループマスターのみ編集できます"
      redirect_to group_path(group)
    end
  end

end
