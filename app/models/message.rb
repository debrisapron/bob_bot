class Message < ActiveRecord::Base

  belongs_to :user

  validates :user, presence: true
  validates :text, presence: true

  scope :since, ->(t) { where('created_at > ?', t).order(:created_at) }

end