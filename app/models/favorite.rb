class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, uniqueness: { scope: :post_id }
  # subject(ポリモーフィック)と1対1の関係を示す
  has_one :notification, as: :subject, dependent: :destroy
  # いいねされた後に、:create_notificationsメソッドを実行
  after_create_commit :create_notifications

  private
    # 通知を作成し、その通知に関連するモデルやアクションの種類を指定する
    # action_typeの名前がnotificationモデルのenumで使われる
    def create_notifications
      Notification.create(subject: self, user: self.post.user, action_type: :favorited_to_own_post)
    end
end
