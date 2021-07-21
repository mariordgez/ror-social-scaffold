class FriendshipsController < ApplicationController
  def create
    @friend = User.find(params[:id])
    @friendship =
      current_user.friendships.new(
        user_id: params[:user_id],
        confirmed: false,
        friend_id: @friend.id,
      )

    if @friendship.save
      redirect_to users_path, notice: 'Friend request was successfully created.'
    else
      timeline_posts
      render :index, alert: 'Friend request was not created.'
    end
  end

  def destroy; end
end
