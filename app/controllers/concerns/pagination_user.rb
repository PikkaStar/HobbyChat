module PaginationUser
  extend ActiveSupport::Concern

  included do
    before_action :set_users, only: [:index]
    before_action :set_show, only: [:show]
  end

  def set_users
    @users = paginate_users
  end

  def paginate_users
    if params[:follows_count]
      Kaminari.paginate_array(User.follows_count).page(params[:page]).per(10)
    elsif params[:follower_count]
      Kaminari.paginate_array(User.follower_count).page(params[:page]).per(10)
    elsif params[:posts]
      Kaminari.paginate_array(User.posts).page(params[:page]).per(10)
    else
      User.page(params[:page]).per(10)
    end
  end

  def set_show
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.same?(current_user)
      set_area
    end
  end

  private
    def set_area
      @isArea = false
      @areaId = nil

      # 上で取得した要素を1つずつ取り出し、それぞれのarea_idが一致するものが存在するか判定
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
end
