var m = require('mithril')
var services = require('./chatroom.services')
var components = require('./chatroom.components')

// Bootstrap the app once we have a current user
services.joinChat().then(function () {
  m.mount(document.body, components)
})