class Relationship < ApplicationRecord
  belongs_to :follower,class_name: "User"
  belongs_to :followed,class_name: "User"
  # subject(ポリモーフィック)と1対1の関係を示す
  has_one :notification, as: :subject, dependent: :destroy
  # フォローされた後に、:create_notificationsメソッドを実行
  after_create_commit :create_notifications
  private
  # 通知を作成し、その通知に関連するモデルやアクションの種類を指定する
  # action_typeの名前がnotificationモデルのenumで使われる
  def create_notifications
    Notification.create(subject: self, user: followed, action_type: :followed_me)
  end



end
