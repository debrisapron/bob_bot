var moment = require('moment')
var m = require('mithril')

var persistedToken = window.localStorage.getItem('token')
var currentUser
var currentMessages = m.prop([])

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

module.exports = {
  joinChat: joinChat,
  postMessage: postMessage,
  currentUser: function () { return currentUser },
  currentMessages: currentMessages
}