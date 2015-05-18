class MessagesController < ApplicationController

  # POST /api/messages
  def create
    Message.create!(allowed_params)
    head :ok
  end

  private

  def allowed_params
    @allowed_params ||= params.require(:message).permit(:user_id, :text)
  end

end