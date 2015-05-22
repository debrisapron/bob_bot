var moment = require('moment')
var m = require('mithril')
var randomColor = require('randomcolor')
var services = require('./chatroom.services')

    var chatroom = (function () {

      function controller() {
        return {
          welcome:
            'Welcome to the chatroom! You are signed in as ' + services.currentUser().name,
          messages: services.currentMessages,
          onkeydown: onkeydown
        }
      }

      function view(ctrl) {
        //console.log(ctrl.messages())
        return m('div.chat-wrap', [
          m('div.welcome', ctrl.welcome),
          m('div.msg-list-wrap', { config: scrollToBottom }, [
            m('div.msg-list', ctrl.messages().map(function (msg) {
              return m.component(message, msg)
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
          services.postMessage(ev.target.value)
          ev.target.value = ''
          return false
        }
      }

      return {
        controller: controller,
        view: view
      }
    })()

    // Must be outside the message component
    // so it is shared between all its instances
    var userColors = {} 

    var message = (function () {

      function controller(msg) {
        var isCU = msg.user.id === services.currentUser().id
        var name = isCU ? 'You' : msg.user.name
        return {
          id: msg.id,
          name: name,
          time: moment(msg.created_at).format('HH:mm:ss'),
          text: msg.text,
          color: userColor(msg, isCU),
          type: msg.type,
          isCU: isCU,
          isPrivate: msg.is_private
        }
      }

      function view(msg) {
        var wrapClass = ['clearfix']
        if(msg.type === 'BobMessage') wrapClass.push('msg-bob')
        if(msg.isPrivate) wrapClass.push('msg-private')
        if(msg.isCU) {
          wrapClass.push('msg-self')
        }
        else {
          wrapClass.push('msg-other')          
        }
        return m('div.msg-wrap', 
          { id: 'msg-' + msg.id, class: wrapClass.join(' ') },
          [msgBodyView(msg)]
        )
      }

      function msgBodyView(ctrl) {
        switch(ctrl.type) {
          case 'UserMessage':
          case 'BobMessage':
            return userMsgBodyView(ctrl)
          case 'JoinMessage':
          case 'LeaveMessage':
            return systemMsgBodyView(ctrl)
        }
      }

      function userMsgBodyView(ctrl) {
        // HACK set the border-color of the bubble :before element by inserting a CSS rule
        document.styleSheets[0].addRule(
          '#msg-' + ctrl.id + ' .bubble:before',
          'border-color: transparent ' + ctrl.color
        )
        return m('div.msg-user', [
          m('div.msg-meta', [
            m('div.msg-name', ctrl.name),
            m('div.msg-time', ctrl.time),
            m('div.msg-privacy', ctrl.isPrivate ? ' (private)' : '')
          ]),
          m('div.bubble', { style: { borderColor: ctrl.color } }, [
            m('div.msg-body', ctrl.text)
          ])
        ])
      }

      function systemMsgBodyView(ctrl) {
        var text =
          ctrl.name + ' ' +
          (ctrl.type === 'JoinMessage' ? 'joined' : 'left') +
          ' the chat'
        return [
          m('div.well.well-sm', text),
        ]
      }

      function userColor(msg, isCU) {
        if(msg.type === 'BobMessage') return '#CCC'
        if(isCU) return '#444'
        return userColors[msg.user.id] || (userColors[msg.user.id] = newColor())
      }

      function newColor() {
        return randomColor({ luminosity: 'light', hue: 'random' })
      }

      return {
        controller: controller,
        view: view
      }
    })()

    module.exports = chatroom