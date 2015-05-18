class MessagesController < ApplicationController

  # POST /api/messages
  def create
    current_user = User.find_by(token: cookies['user_token'])
    Message.create!(allowed_params.merge(user_id: current_user.id))
    head :ok
  end

  private

  def allowed_params
    @allowed_params ||= params.require(:message).permit(:text)
  end

end