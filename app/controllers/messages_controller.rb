class MessagesController < ApplicationController

  # GET /api/messages
  def index
    messages = Message.since(params[:since].to_datetime).for(current_user)
    render json: messages
  end

  # POST /api/messages
  def create
    UserMessage.create!(allowed_params.merge(user_id: current_user.id))
    head :ok
  end

  def allowed_params
    @allowed_params ||= params.require(:message).permit(:text)
  end

end