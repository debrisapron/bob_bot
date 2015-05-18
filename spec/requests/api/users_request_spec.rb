require "rails_helper"

describe "Users API" do

  context "POST" do
    it "creates a new user" do # and returns them as JSON
      post '/api/users'
      expect(response).to be_success
    end
  end

end