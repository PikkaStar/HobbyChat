class User::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    # 非同期
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: @post.id)
    @favorite.save
  end

  def destroy
    # 非同期
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: @post.id).destroy
  end


end
