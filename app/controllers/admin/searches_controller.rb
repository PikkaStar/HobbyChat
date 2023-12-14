class Admin::SearchesController < ApplicationController

  before_action :authenticate_admin!

  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザー"
      @users = User.looks(params[:search],params[:word])
    elsif @range == "投稿"
      @posts = Post.looks(params[:search],params[:word])
    else
      @groups = Group.looks(params[:search],params[:word])
    end
  end

end
