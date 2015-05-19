require "rails_helper"

describe Message do

  it "can be created with a user and text" do
    message = Message.create!(user: test_user, text: 'Booyakasha')
    expect(message.user).to equal test_user
    expect(message.text).to eq 'Booyakasha'
  end

  it "must be created with a user and text" do
    expect{Message.create!}.to raise_error
    expect{Message.create!(user: test_user)}.to raise_error
    expect{Message.create!(text: 'Booyakasha')}.to raise_error
  end

  it "can retrieve all messages since a given time" do
    msgs = Message.since(10.minutes.ago)
    expect(msgs.length).to eq 2
    expect(msgs.first.text).to eq 'Bar'
    expect(msgs.second.text).to eq 'Baz'
  end

end