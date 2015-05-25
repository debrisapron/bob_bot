class Message < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true

  after_create :notify_subscribers

  scope :since, ->(t) { where('created_at > ?', t).order(:created_at) }

  scope :for, ->(u) { where('addressee_id IS NULL OR ? IN (addressee_id, user_id)', u.id) }

  # This is the abstract base class for all the message types
  # so stop it from being instantiated
  def initialize(*args)
    raise "Cannot instantiate the base Message class" if self.class == Message
    super
  end

  protected

  def self.faye_client
    p BobBot::Application.config.faye_url
    @faye_client ||= Faye::Client.new(BobBot::Application.config.faye_url)
  end

  def publish(channel)
    p "Publishing on #{ channel }"
    Message.faye_client.publish(channel, {})
  end

  # REFACTOR putting this here for simplicity, however this is _not_
  # a business domain concern, it is infrastructure, and should be
  # moved to an observer or similar
  def notify_subscribers
    publish('/public_messages')
  end

end