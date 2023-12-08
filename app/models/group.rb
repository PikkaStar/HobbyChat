class Group < ApplicationRecord
  has_many :group_users,dependent: :destroy
  has_many :permits,dependent: :destroy
  has_many :users,through: :group_users,source: :user
  belongs_to :user

  has_one_attached :group_image

  validates :name,presence: true,length: {maximum: 15}
  validates :introduction,presence: true,length: {maximum: 100}

  def get_group_image(width, height)
    if group_image.attached?
      group_image.variant(resize_to_limit: [width, height]).processed
    else
      "no_image"
    end
  end

  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

end
