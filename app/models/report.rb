class Report < ApplicationRecord
  belongs_to :reporter,class_name: "User"
  belongs_to :reported,class_name: "User"

  # has_one :notification, as: :subject, dependent: :destroy

  # after_create_commit :create_notifications

  # 通報理由をenumで
  enum status: { waiting: 0, keep: 1, finish: 2 }

  # private

  # def create_notifications
  #   Notification.create(subject: self, user: self.reporter, action_type: :report_to_own_user)
  # end


end
