class MessagesController < ApplicationController

  # GET /api/messages
  def index
    messages = Message.since(params[:since].to_datetime)
    render json: messages, each_serializer: MessageSerializer
  end

  # POST /api/messages
  def create
    current_user = User.find_by_token(request.authorization.split[1])
    UserMessage.create!(allowed_params.merge(user_id: current_user.id))
    head :ok
  end

  private

  def allowed_params
    @allowed_params ||= params.require(:message).permit(:text)
  end

end