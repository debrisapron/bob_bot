require "rails_helper"

describe User do

  it "has the name UserN after saving where N is its id" do
    user = User.create!
    expect(user.name).to eq "User#{ user.id }"
  end

  it "has a unique token after saving" do
    user = User.create!
    token1 = user.token
    user = User.create!
    token2 = user.token
    expect(token1).to_not be nil
    expect(token1).to_not eq token2
  end

  it "creates a join message after saving" do
    user = User.create!
    expect(JoinMessage.find_by(user_id: user.id)).to_not be nil
  end

end