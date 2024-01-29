class Area < ApplicationRecord
  has_many :talks, dependent: :destroy
  has_many :entries, dependent: :destroy
end
