require "rails_helper"

describe Message do

  it "can retrieve all messages since a given time" do
    msgs = Message.since(10.minutes.ago)
    expect(msgs.length).to eq 5
    expect(msgs.first.text).to eq 'Bar'
    expect(msgs.second.text).to eq 'Baz'
    expect(msgs.third.text).to eq 'Sure.'
    expect(msgs.fourth.type).to eq 'JoinMessage'
    expect(msgs.fifth.text).to eq '@bob u liek pokemans?'
  end

  context UserMessage do

    it "can be created with a user and text or just user" do
      message = UserMessage.create!(user: test_user, text: 'Booyakasha')
      expect(message.user).to equal test_user
      expect(message.text).to eq 'Booyakasha'
      message = UserMessage.create!(user: test_user)
      expect(message.user).to equal test_user
      expect(message.text).to eq nil
    end

    it "must be created with a user" do
      expect{UserMessage.create!}.to raise_error
      expect{UserMessage.create!(text: 'Booyakasha')}.to raise_error
    end

    it "prompts a response from Bob" do
      message = UserMessage.create!(user: test_user, text: 'R U THERE BOB?')
      expect(BobMessage.where(text: 'Woah, chill out! Sure.')).to exist
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
        expect(BobMessage.where.not(id: 4)).to_not exist
      end

    end

    context "PM to Bob" do

      before(:each) do
        @message = UserMessage.create!(
          user: test_user, 
          text: "@bOb I LOVE YOU SO MUCH"
        )
      end

      it "can be seen by the author" do
        expect(Message.for(test_user)).to include @message
      end
    
      it "cannot be seen by other users" do
        another_new_user = User.create!
        expect(Message.for(another_new_user)).to_not include @message
      end

      it "prompts a private response from Bob" do
        resps = BobMessage.where.not(id: 4)
        expect(resps.length).to eq 1
        expect(resps.first.text).to eq '@User1 Woah, chill out!'
      end

    end

  end

  context BobMessage do

    it "can be created with a prompt msg and saves the correct text" do
      msg = UserMessage.create!(user: test_user, text: 'Will it blend?')
      bob_msg = BobMessage.create!(prompt: msg)
      expect(bob_msg.text).to eq 'Sure.'
    end

    it "must be created with a prompt" do
      expect{BobMessage.create!}.to raise_error
    end

    context "PM from Bob" do

      before(:each) do
        msg = UserMessage.create!(user: test_user, text: '@Bob can you even?')
        @message = BobMessage.create!(prompt: msg)
      end

      it "can be seen by the addressee" do
        expect(Message.for(test_user)).to include @message
      end

      it "cannot be seen by other users" do
        new_user = User.create!
        expect(Message.for(new_user)).to_not include @message
      end

    end

  end

end