class Permit < ApplicationRecord
  belongs_to :user
  belongs_to :group
  # subject(ポリモーフィック)と1対1の関係を示す
  has_one :notification, as: :subject, dependent: :destroy
  # 加入申請された後に、:create_notificationsメソッドを実行
  after_create_commit :create_notifications

  private

  def create_notifications
    Notification.create(subject: self, user: self.group.user, action_type: :group_to_own_user)
  end

end
