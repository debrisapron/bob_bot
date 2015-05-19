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
      expect(Message.find_by(user: user, text: 'Foobar')).to_not be nil
    end
  end

  context "GET" do
    it "gets messages since the given time" do
      t = DateTime.now
      user = User.create!
      Message.create!(user: user, text: 'Kazoo')
      get "/api/messages?since=#{ t }"
      expect(response).to be_success
      expect(resp_data.messages.length).to eq 1
      expect(resp_data.messages.first.text).to eq 'Kazoo'
    end
  end

end