require 'rails_helper'

describe "Messages API" do

  context "POST" do
    it "creates a new message and returns OK" do
      user = User.create!
      post '/api/messages', { message: { user_id: user.id, text: 'Foobar' } }
      expect(response).to be_success
      expect(Message.find_by(user: user, text: 'Foobar')).to_not be_nil
    end
  end

end