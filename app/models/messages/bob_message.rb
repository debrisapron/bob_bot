class BobMessage < Message

  def prompt=(user_msg)
    self.text = Bob.respond_to(user_msg)
  end

end