class Post < ApplicationRecord
  has_one_attached :image

  validates :title,presence: true
  validates :body,presence: true,length: {maximum: 200}
  # ソート
  scope :latest, -> {order(created_at: :desc)}
  scope :old, -> {order(created_at: :asc)}
  # includesとはSQLの負担を減らす。1+N問題を解決する記述
  scope :favorite_count, -> {Post.includes(:favorites).sort {|a,b| b.favorites.size <=> a.favorites.size}}
  scope :comment_count, -> {Post.includes(:comments).sort {|a,b| b.comments.size <=> a.comments.size}}
  # そのあとに試したもの
  # scope :favorite_count, -> { Post.includes(:favorites).order(favorite_count: :desc) }
  # scope :comment_count, -> { Post.includes(:comments).order(comment_count: :desc)}

  belongs_to :user
  has_many :favorites,dependent: :destroy
  has_many :comments,dependent: :destroy
  has_many :tag_maps,dependent: :destroy
  has_many :tags,through: :tag_maps
  # subject(ポリモーフィック)と1対1の関係を示す
  has_one :notification, as: :subject, dependent: :destroy

  def get_image(width,height)
    if image.attached?
      image.variant(resize_to_limit: [width,height]).processed
    else
      "no_image"
    end
  end

  def favorited_by?(user)
    self.favorites.exists?(user_id: user.id)
  end

  def self.looks(search,word)
    if search == "partial_match"
     @post = Post.where("title LIKE?","%#{word}%")
    else
     @post = Post.all
    end
  end

  def save_tags(tags)
    # 投稿にタグがすでについているか判定
    # Bookに関連するTagsを取得し、nameを配列として取得する。
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # current_tagsには含まれていてtagsには含まれていない要素
    old_tags = current_tags - tags
    # tagsには含まれていてcurrent_tagsには含まれていない要素
    new_tags = tags - current_tags
    # 更新対象にならなかったタグを取り出す
    old_tags.each do |old_name|
      # 該当するタグを削除
      self.tags.delete Tag.find_by(name: old_name)
    end
      new_tags.each do |new_name|
      # 条件のレコードをはじめの1件所得し、1件もなければ作成する
        tag = Tag.find_or_create_by(name: new_name)
      # 配列追加の要領で新規レコード作成
        self.tags << tag
    end
  end

  def written_by?(current_user)
    user == current_user
  end



end
