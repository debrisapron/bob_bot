class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :addressee,
    class_name: :User

  validates :text, presence: true

  after_create :notify_subscribers

  scope :since, ->(t) { where('created_at > ?', t).order(:created_at) }

  scope :for, ->(u) { where('addressee_id IS NULL OR ? IN (addressee_id, user_id)', u.id) }

  # This is the abstract base class for all the message types
  # so stop it from being instantiated
  def initialize(*args)
    raise "Cannot instantiate the base Message class" if self.class == Message
    super
  end

  def text=(t)
    set_addressee_from_text(t)
    super(t.sub(/^@\S*/, '').strip)
  end

  def set_addressee_from_text(t)
    addr = t.scan(/^@(\S+)/).flatten.first
    return unless addr
    # if addr.downcase == 'bob'
    #   self.addressee_id = Bob.id
    # else
      addr_id = addr[/[0-9]+$/]
      if addr_id && User.exists?(addr_id.to_i)
        self.addressee_id = addr_id.to_i
      end
    # end
  end

  private

  # REFACTOR putting this here for simplicity, however this is _not_
  # a business domain concern, it is infrastructure, and should be
  # moved to an observer or similar
  def notify_subscribers
    # WORKAROUND Not sure why I have to do this dance for a simple publish,
    # but the faye-rails docs are really unhelpful and I'm tired
    client = Faye::Client.new('http://localhost:3000/faye')
    client.publish('/public_message', {})
  end

end