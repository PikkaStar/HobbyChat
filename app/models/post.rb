class Post < ApplicationRecord
  has_one_attached :image

  validates :title,presence: true
  validates :body,presence: true,length: {maximum: 300}

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
