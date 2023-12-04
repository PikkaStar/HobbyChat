class Post < ApplicationRecord
  belongs_to :user

  has_one_attached :image

  validates :title,presence: true
  validates :body,presence: true,length: {maximum: 300}

  def get_image(width,height)
    if image.attached?
      image.variant(resize_to_limit: [width,height]).processed
    else
      "no_image"
    end
  end
end
