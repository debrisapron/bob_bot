require 'rails_helper'

describe "Messages API" do

  context "POST" do
    it "creates a new message and returns OK" do
      user = User.create!
      post(
        '/api/messages',
        { message: { text: 'Foobar' } },
        { Authorization: "Bearer #{ user.token }" }
      )
      expect(response).to be_success
      expect(Message.find_by(user: user, text: 'Foobar')).to_not be_nil
    end
  end

end