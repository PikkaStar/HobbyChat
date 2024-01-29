class Notification < ApplicationRecord
  belongs_to :subject, polymorphic: true
  belongs_to :user

  enum action_type: { commented_to_own_post: 0, favorited_to_own_post: 1, followed_me: 2, group_to_own_user: 3 }
end
