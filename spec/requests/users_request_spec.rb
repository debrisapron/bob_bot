require 'rails_helper'

describe "Users API" do

  context "POST" do
    it "creates a new user and returns them as JSON" do
      post '/api/users'
      expect(response).to be_success
      # resp_data is a helper method located in spec_helper.rb
      expect(resp_data.user.id.to_i).to eq(User.last.id)
      expect(resp_data.user.name).to eq("User#{ resp_data.user.id }")
    end
  end

end