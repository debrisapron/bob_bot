class UserMessage < Message

  after_create :prompt_bob

  validates :user, presence: true

  private

  def prompt_bob
    if addressee_id.nil? || addressee_id == Bob.id
      BobMessage.create!(prompt: self)
    end
  end

end