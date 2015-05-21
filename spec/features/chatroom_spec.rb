require 'rails_helper'

feature 'chatroom', js: true do

  scenario 'joining' do
    visit '/'
    find '.welcome'
    expect(page).to have_content "You are signed in as #{ User.last.name }"
  end

  scenario 'showing existing public messages from previous ten minutes' do
    visit '/'
    find '.msg-list'
    expect(page).to have_content 'Bar'
    expect(page).to have_content 'Baz'
    expect(page).to have_content 'Sure.'
    expect(page).to_not have_content 'Foo'
  end

  # scenario 'posting a comment' do
  #   visit '/'
  #   expect(page).to have_selector '#msg-box'
  #   # FIXME For some reason fill_in is not working right now so using find & set instead
  #   find('#msg-box').set('Foo bar baz')
  #   find('#msg-box').native.send_key(:Enter)
  #   sleep(1)
  #   expect(Message.exists?).to be true
  # end

end