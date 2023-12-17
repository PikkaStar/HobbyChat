class Group < ApplicationRecord
  has_many :group_users,dependent: :destroy
  has_many :users,through: :group_users,source: :user

  has_many :permits,dependent: :destroy
  has_many :permited_users, through: :permits, source: :user

  has_many :group_genres,dependent: :destroy
  has_many :genres,through: :group_genres
  has_many :messages,dependent: :destroy
  has_one :room
  belongs_to :user

  has_one_attached :group_image

  # ソート
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  scope :members, -> {Group.includes(:users).sort {|a,b| b.users.size <=> a.users.size}}

  validates :name,presence: true,length: {maximum: 15}
  validates :introduction,presence: true,length: {maximum: 100}

  def get_group_image(width, height)
    if group_image.attached?
      group_image.variant(resize_to_limit: [width, height]).processed
    else
      "no_image"
    end
  end

  def includesUser?(user)
    group_users.exists?(user_id: user.id)
  end

  def self.looks(search,word)
    if search == "partial_match"
     @group = Group.where("name LIKE?","%#{word}%")
    else
     @group = Group.all
    end
  end

  def save_genres(genres)
    # すでにジャンルを持っている場合はそれを取得
    current_genres = self.genres.pluck(:genre_name) unless self.genres.nil?
    # 古いジャンルを取得
    old_genres = current_genres - genres
    # 新しいジャンルを取得
    new_genres = genres - current_genres

    # 古いジャンルを削除
    old_genres.each do |old_genre|
      self.genres.delete Genre.find_by(genre_name: old_genre)
    end

    # 新しいジャンルを作成し、オブジェクトに関連付ける
    new_genres.each do |new_genre|
      genre = Genre.find_or_create_by(genre_name: new_genre)
      self.genres << genre
    end
  end

end

# create_table :messages do |t|
#   t.text :message
#   t.references :user, foreign_key: true
#   t.references :group, foreign_key: true
#   t.timestamps
# end

# messageをみればどのユーザーのメッセージか、どのグループのメッセージか
# ルームはグループのidを持つ？
# ルーム(チャット)テーブルを作る

# create_table :rooms do |t|
#   t.references :group, foreign_key: true
#   t.timestamps
# end

# Room

#belongs_to :group

# Group
#has_one :room

# roomコントローラーでindexアクションを作って必要な情報
# index.html.erbに記述

# どのグループの会話なのかを判断するためroomsコントローラーのindexアクションに記述
# messageのcreateはmessageコントローラー、

# rooms_controller.rb

# def index
#   @messages = Message.where(gropu_id: params[:group_id])
# end

# link_to rooms_path(group_id: group.id)