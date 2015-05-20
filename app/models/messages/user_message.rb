class UserMessage < Message

  belongs_to :addressee,
    class_name: :User

  validates :text, presence: true

  after_create :prompt_bob

  def text=(t)
    set_addressee_from_text(t)
    super(t)
  end

  def set_addressee_from_text(t)
    addr = t.scan(/^@(\S+)/).flatten.first
    return unless addr
    if addr.downcase == 'bob'
      self.addressee_id = Bob.id
    else
      addr_id = addr[/[0-9]+$/]
      if addr_id && User.exists?(addr_id.to_i)
        self.addressee_id = addr_id.to_i
      end
    end
  end

  def private?
    addressee.present?
  end

  def public?
    !private?
  end

  protected

  def notify_subscribers
    if private?
      publish("/private_messages/#{ user.token }")
      publish("/private_messages/#{ addressee.token }")
    else
      super
    end
  end

  def prompt_bob
    if public? || addressee_id == Bob.id
      BobMessage.create!(prompt: self)
    end
  end

end