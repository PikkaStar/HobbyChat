class User::HomesController < ApplicationController
  def top
    posts = Post.all
    @new_posts = posts.order("RANDOM()").limit(5)
    groups = Group.all
    @new_groups = groups.order("RANDOM()").limit(5)
  end
end
