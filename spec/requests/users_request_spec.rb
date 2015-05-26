require 'rails_helper'

describe "Users API" do

  context "POST" do
    
    context "without auth" do

      it "creates a new user and returns them as JSON" do
        post '/api/users'
        expect(response).to be_success
        # resp_data is a helper method located in spec_helper.rb
        expect(resp_data.user.id.to_i).to eq User.last.id
        expect(resp_data.user.name).to eq "User#{ resp_data.user.id }"
        expect(resp_data.user.token).to_not be nil
        expect(User.where(id: resp_data.user.id)).to exist
      end

      it "creates a join message" do
        post '/api/users'
        expect(JoinMessage.where(user: User.last)).to exist
      end

    end

    context "with auth" do

      it "returns the current user as JSON" do
        post(
          '/api/users',
          nil,
          { Authorization: "Bearer #{ test_user.token }" }
        )
        expect(response).to be_success
        # resp_data is a helper method located in spec_helper.rb
        expect(resp_data.user.id.to_i).to eq test_user.id
        expect(resp_data.user.name).to eq test_user.name
        expect(resp_data.user.token).to eq test_user.token
      end
      
      it "creates a join message" do
        post(
          '/api/users',
          nil,
          { Authorization: "Bearer #{ test_user.token }" }
        )
        expect(JoinMessage.where(user: test_user)).to exist
      end

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
      expect(LeaveMessage.where(user: test_user)).to exist
    end

  end

end