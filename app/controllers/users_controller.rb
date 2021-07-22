class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.ordered_by_most_recent
  end

  def request
    @user = User.find(params[current_user.id])
    @friends = @user.inverse_friends.where(confirmed: false)
  end
end
