require "rails_helper"

describe User do

  it "has the name UserN after saving where N is its id" do
    user = User.create!
    expect(user.name).to eq "User#{ user.id }"
  end

  it "has a nil name before saving" do
    user = User.new
    expect(user.name).to be nil
  end

  it "has a unique token after saving" do
    user = User.create!
    token1 = user.token
    user = User.create!
    token2 = user.token
    expect(token1).to_not be nil
    expect(token1).to_not eq token2
  end

end