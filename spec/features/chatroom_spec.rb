require "rails_helper"

feature "chatroom", js: true do

  before(:each) do
    visit "/"
    find ".welcome"
  end

  scenario "joining" do
    expect(page).to have_content "You are signed in as #{ User.last.name }"
  end

  scenario "showing existing public messages from previous ten minutes" do
    msgs = page.all('.msg-wrap').to_a
    expect(msgs.first).to have_content 'Bar'
    expect(msgs.second).to have_content 'Baz'
    expect(msgs.third).to have_content 'Sure.'
    expect(msgs.fourth).to have_content "User2 joined the chat"
    expect(msgs.fifth).to have_content "You joined the chat"
    expect(page).to_not have_content 'Foo'
  end

  scenario "posting a public comment" do
    p page.body
    find('.msg-box').set("Wahooey\n")
    # find('.msg-box').base.invoke('keypress', false, false, false, false, 13, nil)
    # find('.msg-box').native.send_key(:Enter)
    
    page.execute_script('window.sync();')
    sleep(1)

    p Message.all.pluck(:text)
    p page.body
    p page.all('.msg-body').to_a.map(&:text)
    # # Wait for response from Bob
    # find('.msg-body', text: 'Whatever.')

    # msgs = page.all('.msg-wrap').to_a
    # expect(msgs[5]).to have_content 'Wahooey'
    # expect(msgs[6]).to have_content 'Whatever.'

  end

end