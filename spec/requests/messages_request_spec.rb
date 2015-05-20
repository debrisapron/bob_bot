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
      msgs = resp_data.messages
      expect(msgs.length).to eq 3

      expect(msgs.first.text).to eq 'Bar'
      expect(msgs.first.type).to eq 'UserMessage'
      expect(msgs.first.user.name).to eq 'User1'
      expect(msgs.first.user.token).to be nil

      expect(msgs.second.text).to eq 'Baz'
      expect(msgs.second.type).to eq 'UserMessage'

      expect(msgs.third.text).to eq 'Sure.'
      expect(msgs.third.type).to eq 'BobMessage'
      expect(msgs.third.user.name).to eq 'Bob'
      expect(msgs.third.user.token).to be nil
    end
  end

end