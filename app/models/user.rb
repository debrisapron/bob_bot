require 'securerandom'

class User < ActiveRecord::Base

  before_create :generate_token

  def name
    new_record? ? nil : "User#{ id }"
  end

  private

  def generate_token
    self.token = SecureRandom.uuid
  end

end