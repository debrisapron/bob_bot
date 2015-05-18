require "rails_helper"

describe User do

  it "has the name UserN after saving where N is its id" do
    user = User.create!
    expect(user.name).to eq("User#{ user.id }")
  end

  it "has a nil name before saving" do
    user = User.new
    expect(user.name).to be_nil
  end

end