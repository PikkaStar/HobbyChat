class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

     validates :name,presence: true,length: {in: 2..10}
     validates :introduction,length: {maximum: 200}

     has_many :posts,dependent: :destroy

     has_one_attached :profile_image

     def get_profile_image(width,height)
       if profile_image.attached?
         profile_image.variant(resize_to_limit: [width,height]).processed
       else
         "no_image"
       end
     end

end
