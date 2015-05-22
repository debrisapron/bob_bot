var m = require('mithril')
var chatroomServices = require('./chatroom.services')
var chatroomComponent = require('./chatroom.component')

chatroomServices.init().then(function () {
  m.mount(document.body, chatroomComponent)
})