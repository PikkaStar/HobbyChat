class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

     GUEST_USER_EMAIL = "guest@example.com"

     validates :name,presence: true,length: {in: 2..10}
     validates :introduction,length: {maximum: 200}

     has_many :posts,dependent: :destroy
     has_many :favorites,dependent: :destroy
     has_many :comments,dependent: :destroy

     has_many :group_users,dependent: :destroy
     has_many :permits,dependent: :destroy
     has_many :groups,through: :group_users

     has_many :followers,class_name: "Relationship",foreign_key: "follower_id",dependent: :destroy
     has_many :followeds,class_name: "Relationship",foreign_key: "followed_id",dependent: :destroy
     has_many :following_users,through: :followers,source: :followed
     has_many :follower_users,through: :followeds,source: :follower

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

end
