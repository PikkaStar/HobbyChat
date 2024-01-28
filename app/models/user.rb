class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
     # ゲストのメールアドレス
     GUEST_USER_EMAIL = "guest@example.com"

     validates :name,presence: true,uniqueness: true,length: {in: 2..10}
     validates :introduction,length: {maximum: 200}
     # ソート
     scope :follows_count, -> {User.includes(:following_users).sort {|a,b| b.following_users.size <=> a.following_users.size}}
     scope :follower_count, -> {User.includes(:follower_users).sort {|a,b| b.follower_users.size <=> a.follower_users.size}}
     scope :posts, -> {User.includes(:posts).sort {|a,b| b.posts.size <=> a.posts.size}}
     # 投稿周辺機能
     has_many :posts,dependent: :destroy
     has_many :favorites,dependent: :destroy
     has_many :comments,dependent: :destroy
     # グループ機能
     has_many :group_users,dependent: :destroy
     has_many :permits,dependent: :destroy
     has_many :groups,through: :group_users
     has_many :messages,dependent: :destroy
     # フォロー機能
     has_many :followers,class_name: "Relationship",foreign_key: "follower_id",dependent: :destroy
     has_many :followeds,class_name: "Relationship",foreign_key: "followed_id",dependent: :destroy
     has_many :following_users,through: :followers,source: :followed
     has_many :follower_users,through: :followeds,source: :follower
     # 通知機能
     has_many :reports, class_name: "Report", foreign_key: "reporter_id",dependent: :destroy
     has_many :reverse_of_reports, class_name: "Report", foreign_key: "reported_id",dependent: :destroy
     # DM機能
     has_many :talks,dependent: :destroy
     has_many :entries,dependent: :destroy
     # 通知機能
     has_many :notifications,dependent: :destroy

     has_one_attached :profile_image

     def self.guest
       find_or_create_by!(email: GUEST_USER_EMAIL) do |user|
        # ランダムなパスワードを生成
         user.password = SecureRandom.urlsafe_base64
         user.name = "ゲスト"
       end
     end

     def get_profile_image(width,height)
       if profile_image.attached?
         profile_image.variant(resize_to_limit: [width,height]).processed
       else
         "no_image"
       end
     end

     def follow(user_id)
       followers.create(followed_id: user_id)
     end

     def unfollow(user_id)
       followers.find_by(followed_id: user_id).destroy
     end

     def following?(user)
       following_users.include?(user)
     end

     def self.looks(search,word)
       if search == "partial_match"
        @user = User.where("name LIKE?","%#{word}%")
       else
        @user = User.all
       end
     end

     def same?(current_user)
        self == current_user
     end

     def active_for_authentication?
       super && (is_active == 'true')
     end

end
