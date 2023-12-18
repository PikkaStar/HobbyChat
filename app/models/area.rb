class Area < ApplicationRecord

  has_many :talks
  has_many :entries,dependent: :destroy

end
