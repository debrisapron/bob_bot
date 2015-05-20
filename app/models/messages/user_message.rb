class UserMessage < Message

  after_create :prompt_bob

  validates :user, presence: true

  private

  def prompt_bob
    BobMessage.create!(prompt: text)
  end

end