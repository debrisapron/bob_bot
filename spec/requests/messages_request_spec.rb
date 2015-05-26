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
      expect(Message.where(user: test_user, text: 'Foobar')).to exist
    end
  end

  context "GET" do
    it "gets messages since the given time" do
      get(
        "/api/messages?since=#{ 10.minutes.ago }",
        nil,
        { Authorization: "Bearer #{ test_user.token }" }
      )
      expect(response).to be_success
      expect(resp_data.messages.length).to eq 4
      first, second, third, fourth = resp_data.messages

      expect(first.text).to eq 'Bar'
      expect(first.type).to eq 'UserMessage'
      expect(first.user.name).to eq 'User1'
      expect(first.user.token).to be nil

      expect(second.text).to eq 'Baz'
      expect(second.type).to eq 'UserMessage'

      expect(third.text).to eq 'Sure.'
      expect(third.type).to eq 'BobMessage'
      expect(third.user.name).to eq 'Bob'
      expect(third.user.token).to be nil

      expect(fourth.type).to eq 'JoinMessage'
      expect(fourth.user.name).to eq 'User2'

      # PM for Bob is not returned
    end
  end

end