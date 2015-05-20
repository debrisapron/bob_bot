require "rails_helper"

describe Message do

  it "can retrieve all messages since a given time" do
    msgs = Message.since(10.minutes.ago)
    expect(msgs.length).to eq 3
    expect(msgs.first.text).to eq 'Bar'
    expect(msgs.second.text).to eq 'Baz'
    expect(msgs.third.text).to eq 'Sure.'
  end

  context UserMessage do

    it "can be created with a user and text" do
      message = UserMessage.create!(user: test_user, text: 'Booyakasha')
      expect(message.user).to equal test_user
      expect(message.text).to eq 'Booyakasha'
    end

    it "must be created with a user and text" do
      expect{UserMessage.create!}.to raise_error
      expect{UserMessage.create!(user: test_user)}.to raise_error
      expect{UserMessage.create!(text: 'Booyakasha')}.to raise_error
    end

  end

  context BobMessage do

    it "can be created with a prompt and saves the correct text" do
      message = BobMessage.create!(prompt: 'Will it blend?')
      expect(message.text).to eq 'Sure.'
    end

    it "must be created with a prompt" do
      expect{BobMessage.create!}.to raise_error
    end

  end

end