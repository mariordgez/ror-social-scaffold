class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @friend_requests = current_user.inverted_friendships
    @friends = current_user.friends
    @posts = @user.posts.ordered_by_most_recent
  end
end
