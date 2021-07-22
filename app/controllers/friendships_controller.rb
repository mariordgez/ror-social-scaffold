class FriendshipsController < ApplicationController
  def create
    @friendship =
      current_user.friendships.build(
        user_id: current_user.id,
        friend_id: params[:friend_id],
        confirmed: false,
      )

    if @friendship.save
      redirect_to root_path, notice: 'Friend request was successfully created.'
    else
      redirect_to root_path,
                  notice: 'Friend request was not successfully created.'
    end
  end

  def destroy
    @friendship =
      current_user.friendships.find_by(
        friend_id: params[:friend_id],
        user_id: current_user.id,
      )
    if @friendship == nil
      @friendship =
        current_user.inverse_friendships.find_by(
          friend_id: current_user.id,
          user_id: params[:friend_id],
        )
    else

    end
    @friendship.destroy
    redirect_to current_user, notice: 'Friend was successfully removed'
  end
end
