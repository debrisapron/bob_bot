require "rails_helper"

describe Message do

  it "can be created with a user and text" do
    user = User.create!
    message = Message.create!(user: user, text: 'Booyakasha')
    expect(message.user).to equal user
    expect(message.text).to eq 'Booyakasha'
  end

  it "must be created with a user and text" do
    user = User.create!
    expect{Message.create!}.to raise_error
    expect{Message.create!(user: user)}.to raise_error
    expect{Message.create!(text: 'Booyakasha')}.to raise_error
  end

  it "can retrieve all messages since a given time" do
    user = User.create!
    message1 = Message.create!(user: user, text: 'Booyakasha')
    t = DateTime.now
    message2 = Message.create!(user: user, text: 'TROGDOR')
    message3 = Message.create!(user: user, text: 'omnishambles')
    msgs = Message.since(t)
    expect(msgs.length).to eq 2
    expect(msgs.first).to eq message2
    expect(msgs.second).to eq message3
  end

end