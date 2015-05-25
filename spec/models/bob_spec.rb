require "rails_helper"

describe Bob do

  it "must only ever have one instance with id 0" do
    Message.destroy_all(user: Bob)
    Message.destroy_all(addressee_id: Bob.id)
    Bob.destroy_all
    Bob.create!
    expect(Bob.id).to eq 0
    expect{Bob.create!}.to raise_error
  end

  it "responds to a question with 'Sure.'" do
    resp = Bob.respond_to('Will it blend?')
    expect(resp).to eq 'Sure.'

    # I think '?' counts as a question in the context of internet chat
    resp = Bob.respond_to('?') 
    expect(resp).to eq 'Sure.'
  end

  it "responds to all-caps messages with 'Woah, chill out!'" do
    resp = Bob.respond_to('WILL IT BLEND')
    expect(resp).to eq 'Woah, chill out!'
    resp = Bob.respond_to('WILL IT F1#%2@G BLËND')
    expect(resp).to eq 'Woah, chill out!'
  end

  it "responds to all-caps questions with 'Woah, chill out! Sure.'" do
    resp = Bob.respond_to('WILL IT BLEND?')
    expect(resp).to eq 'Woah, chill out! Sure.'
    resp = Bob.respond_to('WILL IT F1#%2@G BLËND?')
    expect(resp).to eq 'Woah, chill out! Sure.'
  end

  it "responds to nil, empty or all-whitespace messages with 'Fine. Be that way!'" do
    resp = Bob.respond_to(nil)
    expect(resp).to eq 'Fine. Be that way!'
    resp = Bob.respond_to('')
    expect(resp).to eq 'Fine. Be that way!'
    resp = Bob.respond_to('   ')
    expect(resp).to eq 'Fine. Be that way!'
    resp = Bob.respond_to("  \n ")
    expect(resp).to eq 'Fine. Be that way!'
  end

  it "responds to any other messages with 'Whatever.'" do
    resp = Bob.respond_to('Will it blend')
    expect(resp).to eq 'Whatever.'
    resp = Bob.respond_to('*%*&^%$$$£& )(&*^')
    expect(resp).to eq 'Whatever.'
    resp = Bob.respond_to('1')
    expect(resp).to eq 'Whatever.'
  end

end