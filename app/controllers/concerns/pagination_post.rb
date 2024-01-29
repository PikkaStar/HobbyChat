module PaginationPost
  extend ActiveSupport::Concern

  included do
    before_action :set_posts, only: [:index]
  end

  def set_posts
    @posts = paginate_posts
  end

  def paginate_posts
    if params[:latest]
      Post.latest.page(params[:page]).per(10)
    elsif params[:old]
      Post.old.page(params[:page]).per(10)
    elsif params[:favorite_count]
      # ソートしたデータをpaginateするにはKaminari.paginate_arrayが必要
      Kaminari.paginate_array(Post.favorite_count).page(params[:page]).per(10) # Post.favorite_count
    elsif params[:comment_count]
      Kaminari.paginate_array(Post.comment_count).page(params[:page]).per(10)
    else
      Post.page(params[:page]).per(10)
    end
  end
end
