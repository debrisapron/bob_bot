require 'rails_helper'

describe "Users API" do

  context "POST" do
    it "creates a new user and returns them as JSON" do
      post '/api/users'
      expect(response).to be_success
      # resp_data is a helper method located in spec_helper.rb
      expect(resp_data.user.id.to_i).to eq User.last.id
      expect(resp_data.user.name).to eq "User#{ resp_data.user.id }"
      expect(resp_data.user.token).to_not be nil
      expect(User.find_by(id: resp_data.user.id)).to_not be nil
    end
  end

  context "DELETE" do
    it "creates a leave message for the current user" do
      delete(
        '/api/users',
        nil,
        { Authorization: "Bearer #{ test_user.token }" }
      )
      expect(response).to be_success
      expect(LeaveMessage.find_by(user: test_user)).to_not be nil
    end
  end

end