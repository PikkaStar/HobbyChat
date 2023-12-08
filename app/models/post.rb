class Post < ApplicationRecord
  has_one_attached :image

  validates :title,presence: true
  validates :body,presence: true,length: {maximum: 300}

  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :favorite_count, -> {Post.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}}
  scope :comment_count, -> {Post.includes(:comments).sort {|a,b| b.comments.size <=> a.comments.size}}
  # そのあとに試したもの
  # scope :favorite_count, -> { Post.includes(:favorites).order(favorite_count: :desc) }
  # scope :comment_count, -> { Post.includes(:comments).order(comment_count: :desc)}

  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :comments,dependent: :destroy

  def get_image(width,height)
    if image.attached?
      image.variant(resize_to_limit: [width,height]).processed
    else
      "no_image"
    end
  end

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

end
