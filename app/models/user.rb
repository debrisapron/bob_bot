require 'hashids'

class User < ActiveRecord::Base

  SECRET = Rails.application.secrets.secret_key_base

  def self.find_by_token(token)
    find_by(id: hashids.decode(token))
  end

  def name
    "User#{ id }"
  end

  def token
    @token ||= User.hashids.encode(id)
  end

  private

  def self.hashids
    @hashids ||= Hashids.new(SECRET, 20)
  end

end