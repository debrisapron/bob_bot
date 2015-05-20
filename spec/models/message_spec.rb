require "rails_helper"

describe Message do

  it "can retrieve all messages since a given time" do
    msgs = Message.since(10.minutes.ago)
    expect(msgs.length).to eq 3
    expect(msgs.first.text).to eq 'Bar'
    expect(msgs.second.text).to eq 'Baz'
    expect(msgs.third.text).to eq 'Sure.'
  end

  context UserMessage do

    it "can be created with a user and text" do
      message = UserMessage.create!(user: test_user, text: 'Booyakasha')
      expect(message.user).to equal test_user
      expect(message.text).to eq 'Booyakasha'
    end

    it "must be created with a user and text" do
      expect{UserMessage.create!}.to raise_error
      expect{UserMessage.create!(user: test_user)}.to raise_error
      expect{UserMessage.create!(text: 'Booyakasha')}.to raise_error
    end

    it "prompts a response from Bob" do
      message = UserMessage.create!(user: test_user, text: 'R U THERE BOB?')
      expect(BobMessage.find_by(text: 'Woah, chill out! Sure.')).to_not be nil
    end

    context "PM to another user" do
      
      before(:each) do
        @new_user = User.create!
        @message = UserMessage.create!(
          user: test_user, 
          text: "@#{ @new_user.name } how u doin?"
        )
      end

      it "can be seen by the author" do
        expect(Message.for(test_user)).to include @message
      end
    
      it "can be seen by the addressee" do
        expect(Message.for(@new_user)).to include @message
      end
    
      it "cannot be seen by other users" do
        another_new_user = User.create!
        expect(Message.for(another_new_user)).to_not include @message
      end

      it "does not prompt a response from Bob" do
        expect(BobMessage.where.not(id: 4)).to be_empty
      end

    end

    # context "PM to Bob" do

    #   before(:each) do
    #     @message = UserMessage.create!(
    #       user: test_user, 
    #       text: "@bOb I LOVE YOU SO MUCH"
    #     )
    #   end

    #   it "can be seen by the author" do
    #     expect(Message.for(test_user)).to include @message
    #   end
    
    #   it "cannot be seen by other users" do
    #     another_new_user = User.create!
    #     expect(Message.for(another_new_user)).to_not include @message
    #   end

    #   # it "prompts a private response from Bob" do
    #   #   resps = BobMessage.where.not(id: 4)
    #   #   expect(resps.length).to eq 1
    #   #   expect(resps.first.text).to eq 'Woah, chill out!'
    #   # end

    # end

  end

  context BobMessage do

    it "can be created with a prompt and saves the correct text" do
      message = BobMessage.create!(prompt: 'Will it blend?')
      expect(message.text).to eq 'Sure.'
    end

    it "must be created with a prompt" do
      expect{BobMessage.create!}.to raise_error
    end

  end

end