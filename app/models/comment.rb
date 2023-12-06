class Comment < ApplicationRecord

  validates :comment,presence: true,length: {maximum: 50}

  belongs_to :user
  belongs_to :post

end
