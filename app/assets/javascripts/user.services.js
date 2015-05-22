var m = require('mithril')
var moment = require('moment')

var persistedToken = window.localStorage.getItem('token')
var currentUser

function init() {
  return joinChat().then(function (user) {
    currentUser = user
    if(!persistedToken) window.localStorage.setItem('token', user.token)
    waitForUnload()
    return user
  })
}

function joinChat() {
  return m.request({
    method: 'POST',
    url: '/api/users',
    config: configAuth,
    unwrapSuccess: function(response) {
      return response.user
    }
  })
}

function leaveChat() {
  return m.request({
    method: 'DELETE',
    url: '/api/users',
    config: configAuth
  })
}

function configAuth(xhr) {
  var token = (currentUser && currentUser.token) || persistedToken
  if(token) {
    xhr.setRequestHeader('Authorization', 'Bearer ' + token)
  }
}

function waitForUnload() {
  window.onbeforeunload = function () {
    leaveChat()
    return null
  }
}

module.exports = {
  init: init,
  currentUser: function () { return currentUser },
  configAuth: configAuth
}