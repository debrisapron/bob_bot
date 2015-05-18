class UsersController < ApplicationController

  # POST /api/users
  def create
    User.create!
    head :ok
  end

end