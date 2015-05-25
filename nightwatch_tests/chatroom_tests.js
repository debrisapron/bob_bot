var childProcess = require('child_process')
var events = require('events')

var railsServer
var userA = {}
var userB = {}

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
  browser.waitForMsg = function (index) {
    var args = Array.prototype.slice.call(arguments);
    var css = '.msg-wrap:nth-child(' + index + ')'
    args.shift()
    args.forEach(function (text) { browser.waitForText(css, text) })
    return browser
  }
  browser.getName = function (user) {
    browser.getText('.welcome', function (text) { 
      user.name = text.value.match(/User[0-9]+/)[0]
    })
    return browser
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
      .getName(userA)
      .waitForMsg(1, 'You joined the chat')
  },

  'post a public message and be told "whatever" by Bob': function (br) {
    br.setValue('textarea', 'foo bar baz\n')
      .waitForMsg(2, 'You', 'foo bar baz')
      .waitForMsg(3, 'Bob', 'Whatever.')
  },

  'post a public all-caps message and get told to chill out by Bob': function (br) {
    br.setValue('textarea', 'OMGROFL\n')
      .waitForMsg(4, 'You', 'OMGROFL')
      .waitForMsg(5, 'Bob', 'Woah, chill out!')
  },

  'post a public question and get "Sure." reply from Bob': function (br) {
    br.setValue('textarea', 'will it blend?\n')
      .waitForMsg(6, 'You', 'will it blend?')
      .waitForMsg(7, 'Bob', 'Sure.')
  },

  'post an empty message and get rebuked by Bob': function (br) {
    br.setValue('textarea', '\n')
      .waitForMsg(8, 'You')
      .waitForMsg(9, 'Bob', 'Fine. Be that way!')
  },

  'post a private message to bob and get a private response': function (br) {
    br.setValue('textarea', '@bob are we friends?\n')
      .waitForMsg(10, 'You', '@bob are we friends?')
      .waitForMsg(11, 'Bob', 'Sure.')
  },

  'open chatroom in new window as user B': function (br) {
    // We've disable localStorage using a chrome flag in nightwatch.json
    // so we'll get a new user in our new window
    br.execute(function () {
        window.open('http://localhost:3001', 'userB', 'height=700,width=600')
      })
      .windowHandles(function (handles) {
        userA.handle = handles.value[0]
        userB.handle = handles.value[1]
      })
  },

  'as user B see public messages betwen user A and Bob, and own join notification': function (br) {
    br.switchWindow(userB.handle)
      .pause(100)
      .getName(userB)
      .waitForMsg(1, userA.name + ' joined the chat')
      .waitForMsg(2, userA.name, 'foo bar baz')
      .waitForMsg(3, 'Bob', 'Whatever.')
      .waitForMsg(4, userA.name, 'OMGROFL')
      .waitForMsg(5, 'Bob', 'Woah, chill out!')
      .waitForMsg(6, userA.name, 'will it blend?')
      .waitForMsg(7, 'Bob', 'Sure.')
      .waitForMsg(8, userA.name)
      .waitForMsg(9, 'Bob', 'Fine. Be that way!')
      // note absence of private message to bob
      .waitForMsg(10, 'You joined the chat')
  },

  'as user B post a public message and Bob responds': function (br) {
    br.setValue('textarea', 'I feel like chicken tonight\n')
      .waitForMsg(11, 'You', 'I feel like chicken tonight')
      .waitForMsg(12, 'Bob', 'Whatever.')
  },

  'as user B post a private message for user A without response from Bob': function (br) {
    br.setValue('textarea', '@' + userA.name + ' Bob seems kind of dumb\n')
      .pause(100)
      .setValue('textarea', '@' + userA.name + ' Am I right?\n')
      .waitForMsg(13, 'You', '@' + userA.name + ' Bob seems kind of dumb')
      .waitForMsg(14, 'You', '@' + userA.name + ' Am I right?')
  },

  'user A sees a join notification for user B and their public & private messages': function (br) {
    br.switchWindow(userA.handle)
      .waitForMsg(12, userB.name + ' joined the chat')
      .waitForMsg(13, userB.name, 'I feel like chicken tonight')
      .waitForMsg(14, 'Bob', 'Whatever.')
      .waitForMsg(15, userB.name, '@' + userA.name + ' Bob seems kind of dumb')
      .waitForMsg(16, userB.name, '@' + userA.name + ' Am I right?')
  },

  after: function (browser) {
    browser.end()
    stopRails()
  }

}