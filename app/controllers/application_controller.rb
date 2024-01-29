class ApplicationController < ActionController::Base
  private
    def reset_guest_data
      guest_user = User.find_by(email: User::GUEST_USER_EMAIL)
      # guest_userが作成した項目を全削除
      guest_user.posts.destroy_all if guest_user.posts.any?
      guest_user.favorites.destroy_all if guest_user.favorites.any?
      guest_user.comments.destroy_all if guest_user.comments.any?
      guest_user.groups.destroy_all if guest_user.groups.any?
    end
end
