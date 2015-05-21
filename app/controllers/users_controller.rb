class UsersController < ApplicationController

  # POST /api/users
  def create
    user = User.create!
    render json: user, serializer: CurrentUserSerializer, root: :user
  end

  # DELETE /api/users
  def destroy
    LeaveMessage.create!(user: current_user)
    head :ok
  end

end