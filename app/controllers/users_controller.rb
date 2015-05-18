class UsersController < ApplicationController

  # POST /api/users
  def create
    user = User.create!
    render json: user
  end

end