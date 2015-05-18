require 'rails_helper'

describe "Messages API" do

  context "POST" do
    it "creates a new message and returns OK" do
      user = User.create!
      cookies['user_token'] = user.token
      post '/api/messages', { message: { text: 'Foobar' } }
      expect(response).to be_success
      expect(Message.find_by(user: user, text: 'Foobar')).to_not be_nil
    end
  end

end