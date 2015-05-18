class UsersController < ApplicationController

  # POST /api/users
  def create
    User.create!
    
  end

end