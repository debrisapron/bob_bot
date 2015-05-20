class BobMessage < Message

  def prompt=(user_msg)
    response = Bob.respond_to(user_msg.text.sub(/^@\S*/, '').strip)
    response = "@#{ user_msg.user.name } #{ response }" if user_msg.private?
    self.text = response
  end

end