require "rails_helper"

describe Message do

  it "can be created with a user and text" do
    user = User.create!
    message = Message.create!(user: user, text: 'Booyakasha')
    expect(message.user).to equal(user)
    expect(message.text).to eq('Booyakasha')
  end

  it "must be created with a user and text" do
    user = User.create!
    expect{Message.create!}.to raise_error
    expect{Message.create!(user: user)}.to raise_error
    expect{Message.create!(text: 'Booyakasha')}.to raise_error
  end

end