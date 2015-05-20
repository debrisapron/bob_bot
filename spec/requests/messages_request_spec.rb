require 'rails_helper'

describe "Messages API" do

  context "POST" do
    it "creates a new message and returns OK" do
      post(
        '/api/messages',
        { message: { text: 'Foobar' } },
        { Authorization: "Bearer #{ test_user.token }" }
      )
      expect(response).to be_success
      expect(Message.find_by(user: test_user, text: 'Foobar')).to_not be nil
    end
  end

  context "GET" do
    it "gets messages since the given time" do
      get "/api/messages?since=#{ 10.minutes.ago }"
      expect(response).to be_success
      expect(resp_data.messages.length).to eq 2
      expect(resp_data.messages.first.text).to eq 'Bar'
      expect(resp_data.messages.second.text).to eq 'Baz'
      expect(resp_data.messages.first.user.name).to eq 'User1'
    end
  end

end