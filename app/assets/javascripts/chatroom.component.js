var m = require('mithril')
var userServices = require('./user.services')
var messageServices = require('./message.services')
var messageComponent = require('./message.component')

function controller() {
  return {
    welcome:
      'Welcome to the chatroom! You are signed in as ' + userServices.currentUser().name,
    messages: messageServices.currentMessages,
    onkeydown: onkeydown
  }
}

function view(ctrl) {
  return m('div.chat-wrap', [
    m('div.welcome', ctrl.welcome),
    m('div.msg-list-wrap', { config: scrollToBottom }, [
      m('div.msg-list', ctrl.messages().map(function (msg) {
        return m.component(messageComponent, msg)
      }))
    ]),
    m('textarea.msg-box',
      { autofocus: 1, rows: 3, onkeydown: ctrl.onkeydown }
    )
  ])
}

function scrollToBottom(ele) {
  ele.scrollTop = ele.scrollHeight
}

function onkeydown(ev) {
  if(ev.keyCode === 13) {
    messageServices.postMessage(ev.target.value)
    ev.target.value = ''
    return false
  }
}

module.exports = {
  controller: controller,
  view: view
}