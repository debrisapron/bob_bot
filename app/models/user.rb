require 'jwt'

class User < ActiveRecord::Base

  SECRET = Rails.application.secrets.secret_key_base

  after_create :create_join_message

  def self.find_by_token(token)
    id = JWT.decode(token, SECRET)[0]['id'].to_i
    find(id)
  end

  def name
    "User#{ id }"
  end

  def token
    @token ||= JWT.encode({ id: id }, SECRET)
  end

  private

  def create_join_message
    JoinMessage.create!(user: self)
  end

end