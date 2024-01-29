class Talk < ApplicationRecord
  belongs_to :user
  belongs_to :area

  validates :message, presence: true
end
