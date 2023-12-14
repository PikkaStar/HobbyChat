module User::NotificationsHelper
  def transition_path(notification)
    # 通知のaction_typeをシンボルに変換し、それによって行われるアクションを判断
    case notification.action_type.to_sym
    when :commented_to_own_post
      # 通知が関連付けられた投稿へのパスを返す
      # anchorとは、ユーザーがクリックしたときにコメント部分までスクロールする
      post_path(notification.subject.post, anchor: "comment-#{notification.subject.id}")
    when :favorited_to_own_post
      # いいねが関連付けられた投稿へのパスを返す
      post_path(notification.subject.post)
    when :followed_me
      # フォロワーのプロフィールページへのパスを返す
      user_path(notification.subject.follower)
    when :group_to_own_user
      group_path(notification.subject.group)
    end
  end
end
