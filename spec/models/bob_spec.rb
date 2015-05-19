require "rails_helper"

describe Bob do

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
    resp = Bob.respond_to('WILL IT F1#%2@G BLEND')
    expect(resp).to eq 'Woah, chill out!'
  end

  it "responds to all-caps questions with 'Whoah, chill out! Sure.'" do
    resp = Bob.respond_to('WILL IT BLEND?')
    expect(resp).to eq 'Woah, chill out! Sure.'
    resp = Bob.respond_to('WILL IT F1#%2@G BLEND?')
    expect(resp).to eq 'Woah, chill out! Sure.'
  end

  it "responds to empty or all-whitespace messages with 'Fine. Be that way!'" do
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