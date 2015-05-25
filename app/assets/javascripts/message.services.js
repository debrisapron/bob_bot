var m = require('mithril')
var moment = require('moment')
var Faye = require('faye/browser/faye-browser')
var userServices = require('./user.services')

var currentMessages = m.prop([])

function init() {
  sync()
  subscribeToNewMessages()
}

function postMessage(text) {
  return m.request({
    method: 'POST',
    url: '/api/messages',
    config: userServices.configAuth,
    data: { message: { text: text } }
  })
}

function sync() {
  getMessageList().then(merge)
}

function getMessageList(first) {
  return m.request({
    method: 'GET',
    url: '/api/messages?since=' + lastMessageTime().toISOString(),
    config: userServices.configAuth,
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

function subscribeToNewMessages() {
  var fayeClient = new Faye.Client('/faye')
  fayeClient.subscribe('/public_messages', sync)
  fayeClient.subscribe('/private_messages/' + userServices.currentUser().token, sync)
}

module.exports = {
  init: init,
  postMessage: postMessage,
  currentMessages: currentMessages
}