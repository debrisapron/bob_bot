require "rails_helper"

describe "Users API" do

  context "POST" do
    it "creates a new user and returns them as JSON" do
      post '/api/users'
      expect(response).to be_success
    end
  end

end