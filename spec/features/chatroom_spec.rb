require 'rails_helper'

feature 'chatroom', js: true do

  scenario 'joining' do
    visit '/'
    expect(User.exists?).to be true
  end

  scenario 'posting a comment' do
    visit '/'
    expect(page).to have_selector('#msg-box')
    # FIXME For some reason fill_in is not working right now so using find & set instead
    find('#msg-box').set('Foo bar baz')
    find('#msg-box').native.send_key(:Enter)
    expect(Message.exists?).to be true
  end

end