# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

  Admin.create!(
    email: "admin@admin.com",
    password: "123456"
  )

  10.times do |n|
  user = User.create!(
    name: "試験#{n + 1}",
    email: "test#{n + 1}@test.com",
    password: "100100",
    introduction: "テストユーザー#{n + 1}です"
  )

  # ユーザーがランダムな件数のpostを作成し、その中からランダムな件数にfavoriteをつける
  rand(1..3).times do
    post = user.posts.create!(
      title: "テストタイトル#{n + 1}",
      body: "テスト内容#{n + 1}"
    )
  end

  users = User.all
  posts = Post.all

  users.each do |user|
  favorite_posts = posts.sample(rand(1..5))
  favorite_posts.each do |post|
    Favorite.find_or_create_by!(
      user_id: user.id,
      post_id: post.id
    )
    end
  end

  users.each do |user|
    comment_posts = posts.sample(rand(1..5))
    comment_posts.each do |post|
      Comment.find_or_create_by!(
        user_id: user.id,
        post_id: post.id,
        comment: "テストコメント#{n + 1}"
        )
    end
  end

  users.each do |user|
  following_users = users - [user]
  following_users.shuffle.take(rand(1..4)).each do |following_user|
    Relationship.find_or_create_by!(
      follower_id: user.id,
      followed_id: following_user.id
    )
    end
  end
end
    # owner = User.find(rand(1..10))
    # group = Group.create!(
    # name: "テストグループ",
    # introduction: "テスト",
    # owner_id: owner.id,
    # user: owner
    # )
    # # オーナーをグループに入れる
    # GroupUser.create!(group: group,user: owner)
    # # オーナー以外をランダムに入れる
    # rand(1..3).times do |i|
    #   GroupUser.create!(group: group,user: User.find(i + 1))
    #   end
    # グループ作成
  3.times do
    owner = User.find(rand(1..10))
    group = Group.create!(
      name: "テストグループ",
      introduction: "テスト",
      owner_id: owner.id,
      user: owner
    )

    # グループに加入するユーザーの数をランダムに決定
    num_users_to_join = rand(1..5)

    # オーナーをグループに加入
    GroupUser.create!(group: group, user: owner)

    # オーナー以外のユーザーをランダムにグループに加入
    (1..num_users_to_join).each do |i|
      GroupUser.create!(group: group, user: User.find(i + 1))
    end
  end


