class UserMessage < Message

  after_create :prompt_bob

  validates :user, presence: true

  protected

  def notify_subscribers
    if private?
      publish("/private_messages/#{ user.token }")
      publish("/private_messages/#{ addressee.token }")
    else
      super
    end
  end

  private

  def prompt_bob
    if addressee_id.nil? || addressee_id == Bob.id
      BobMessage.create!(prompt: self)
    end
  end

end