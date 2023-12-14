class Permit < ApplicationRecord
  belongs_to :user
  belongs_to :group

  has_one :notification, as: :subject, dependent: :destroy

  after_create_commit :create_notifications

  private

  def create_notifications
    Notification.create(subject: self, user: self.group.user, action_type: :group_to_own_user)
  end

end
