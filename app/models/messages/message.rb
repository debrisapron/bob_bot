class Message < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true
  validates :text, presence: true

  after_create :notify_subscribers

  scope :since, ->(t) { where('created_at > ?', t).order(:created_at) }

  # This is the abstract base class for all the message types
  # so stop it from being instantiated
  def initialize(*args)
    raise "Cannot instantiate the base Message class" if self.class == Message
    super
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