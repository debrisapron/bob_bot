var childProcess = require('child_process')
var events = require('events')

var railsServer
var userA
var userB

function startRails() {
  console.log("spawning test rails server")
  railsServer = childProcess.spawn(
    'rails', ['s', '-p', '3001', '-e', 'test']
  )
}

function stopRails() {
  console.log("killing test rails server")
  railsServer.kill()
  railsServer.kill() // Don't ask me why you need to do this twice
}

function addCustomCommands(browser) {
  browser.waitForText = function (css, text) {
    browser.waitForElementVisible(css)
    if(text) browser.assert.containsText(css, text)
    return browser
  }
  browser.waitForMsg = function (index, text) {
    var css = '.msg-wrap:nth-child(' + index + ')'
    return browser.waitForText(css, text)
  }
}

module.exports = {

  before: function (br) {
    startRails()
    addCustomCommands(br)
    events.EventEmitter.defaultMaxListeners = 0 // https://github.com/beatfactor/nightwatch/issues/408
    br.url('http://localhost:3001')
  },

  'see welcome message and join notification': function (br) {
    br.waitForText('.welcome', 'You are signed in as User')
      .waitForMsg(1, 'You joined the chat')
  },

  'post a public message and be told "whatever" by Bob': function (br) {
    br.setValue('textarea', 'foo bar baz\n')
      .waitForMsg(2, 'foo bar baz')
      .waitForMsg(3, 'Whatever.')
  },

  'post a public all-caps message and get told to chill out by Bob': function (br) {
    br.setValue('textarea', 'OMGROFL\n')
      .waitForMsg(4, 'OMGROFL')
      .waitForMsg(5, 'Woah, chill out!')
  },

  'post a public question and get "Sure." reply from Bob': function (br) {
    br.setValue('textarea', 'will it blend?\n')
      .waitForMsg(6, 'will it blend?')
      .waitForMsg(7, 'Sure.')
  },

  'post an empty message and get rebuked by Bob': function (br) {
    br.setValue('textarea', '\n')
      .waitForMsg(8, '')
      .waitForMsg(9, 'Fine. Be that way!')
  },

  'post a private message to bob and get a private response': function (br) {
    br.setValue('textarea', '@bob are we friends?\n')
      .waitForMsg(10, '@bob are we friends?')
      .waitForMsg(11, 'Sure.')
  },

  'open chatroom in new window as user B': function (br) {
    // We've disable localStorage using a chrome flag in nightwatch.json
    // so we'll get a new user in our new window
    br.execute(function () {
        window.open('http://localhost:3001', 'userB', 'height=700,width=600')
      })
      .windowHandles(function (handles) {
        userA = handles.value[0]
        userB = handles.value[1]
      })
  },

  'as user B see public messages betwen user A and Bob, and own join notification': function (br) {
    br.switchWindow(userB)
      .waitForMsg(1, 'joined the chat')
      .waitForMsg(2, 'foo bar baz')
      .waitForMsg(3, 'Whatever.')
      .waitForMsg(4, 'OMGROFL')
      .waitForMsg(5, 'Woah, chill out!')
      .waitForMsg(6, 'will it blend?')
      .waitForMsg(7, 'Sure.')
      .waitForMsg(8, '')
      .waitForMsg(9, 'Fine. Be that way!')
      // note absence of private message
      .waitForMsg(10, 'You joined the chat')
  },

  'as user B post a public message and Bob responds': function (br) {
    br.setValue('textarea', 'I feel like chicken tonight\n')
      .waitForMsg(11, 'I feel like chicken tonight')
      .waitForMsg(12, 'Whatever.')
  },

  'user A sees a join notification for user B and their public messages': function (br) {
    br.switchWindow(userA)
      .waitForMsg(12, 'joined the chat')
      .waitForMsg(13, 'I feel like chicken tonight')
      .waitForMsg(14, 'Whatever.')
  },

  after: function (browser) {
    browser.end()
    stopRails()
  }

}