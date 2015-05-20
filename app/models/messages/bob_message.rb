class BobMessage < UserMessage

  before_validation :set_user_id

  def prompt=(user_msg)
    response = Bob.respond_to(user_msg.text.sub(/^@\S*/, '').strip)
    response = "@#{ user_msg.user.name } #{ response }" if user_msg.private?
    self.text = response
  end

  protected

  def prompt_bob; end

  private

  def set_user_id
    self.user_id = Bob.id
  end

end