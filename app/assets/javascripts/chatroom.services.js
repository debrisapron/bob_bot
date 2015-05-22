var userServices = require('./user.services')
var messageServices = require('./message.services')

function init() {
  return userServices.init().then(messageServices.init)
}

module.exports = {
  init: init
}