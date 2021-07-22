class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @user_req = current_user.inverse_friendships.unconfirmed_friend
    @friendships = current_user.friendships.where(confirmed: true)
    @inverse_friendships =
      current_user.inverse_friendships.where(confirmed: true)
    @posts = @user.posts.ordered_by_most_recent
  end
end
