require 'rails_helper'

feature 'the lobby' do

  scenario 'entering the lobby' do
    visit '/'
    expect(page).to have_content 'You are lurking'
  end

end