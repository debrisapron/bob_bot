(function () {

  var persistedToken = window.localStorage.getItem('token')
  var currentUser
  var currentMessages = m.prop([])

  // API services
  var services = (function () {

    function joinChat() {
      return m
        .request({
          method: 'POST',
          url: '/api/users',
          config: configAuth,
          unwrapSuccess: function(response) {
            return response.user
          }
        })
        .then(function (user) {
          currentUser = user
          if(!persistedToken) window.localStorage.setItem('token', user.token)
          sync()
          subscribeToNewMessages()
          waitForUnload()
          return user
        })
    }

    function postMessage(text) {
      return m.request({
        method: 'POST',
        url: '/api/messages',
        config: configAuth,
        data: { message: { text: text } }
      })
    }

    function leaveChat() {
      return m.request({
        method: 'DELETE',
        url: '/api/users',
        config: configAuth
      })
    }

    function sync() {
      getMessageList().then(merge)
    }

    function getMessageList(first) {
      return m.request({
        method: 'GET',
        url: '/api/messages?since=' + lastMessageTime().toISOString(),
        config: configAuth,
        unwrapSuccess: function(response) {
          return response.messages
        }
      })
    }

    function merge(newMessages) {
      var lmt = moment(lastMessageTime())
      var cms = currentMessages()
      newMessages.forEach(function (msg) {
        if(moment(msg.created_at).isAfter(lmt)) cms.push(msg)
      })
      currentMessages(cms)
    }

    function lastMessageTime() {
      var cms = currentMessages()
      return cms.length ?
        moment(cms[cms.length -1].created_at) :
        moment.utc().subtract(10, 'minutes')
    }

    function configAuth(xhr) {
      var token = (currentUser && currentUser.token) || persistedToken
      if(token) {
        xhr.setRequestHeader('Authorization', 'Bearer ' + token)
      }
    }

    function subscribeToNewMessages() {
      var fayeClient = new Faye.Client('/faye')
      fayeClient.subscribe('/public_messages', sync)
      fayeClient.subscribe('/private_messages/' + currentUser.token, sync)
    }

    function waitForUnload() {
      window.onbeforeunload = function () {
        leaveChat()
        return null
      }
    }

    return {
      joinChat: joinChat,
      postMessage: postMessage
    }
  })()

  // Display components
  var components = (function () {

    var chatroom = (function () {

      function controller() {
        return {
          welcome:
            'Welcome to the chatroom! You are signed in as ' + currentUser.name,
          messages: currentMessages,
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
        var isCU = msg.user.id === currentUser.id
        var name = isCU ? 'You' : msg.user.name
        return {
          id: msg.id,
          name: name,
          time: moment(msg.created_at).format('HH:mm:ss'),
          text: msg.text,
          color: userColor(msg),
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

      function userColor(msg) {
        if(msg.type === 'BobMessage') return '#CCC'
        var id = msg.user.id
        if(id === currentUser.id) return '#444'
        return userColors[id] || (userColors[id] = newColor())
      }

      function newColor() {
        return randomColor({ luminosity: 'light', hue: 'random' })
      }

      return {
        controller: controller,
        view: view
      }
    })()

    return {
      chatroom: chatroom
    }
  })()

  // Bootstrap the app oncce we have a current user
  services.joinChat().then(function () {
    m.mount(document.body, components.chatroom)
  })
})()