class User::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :guest_user,only: [:create,:destroy]

  def create
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.new(post_id: @post.id)
    @favorite.save
  end

  def destroy
    @post = Post.find(params[:post_id])
    @favorite = current_user.favorites.find_by(post_id: @post.id).destroy
  end

  private

  def guest_user
    user = current_user
    if user.email == "guest@example.com"
      flash[:alert] = "ゲストの方は行えません"
      redirect_to posts_path
    end
  end
end
