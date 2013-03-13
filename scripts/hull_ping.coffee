# Description:
#   Allows to check that an app behaves as expected by sending messages from PhantomJS
#   Useful for integration testing
#
# Dependencies:
#   "clouseau" : "0.1.0"
#
# Commands:
#   hubot clouseau - Follows the execution of your app
#
# Configuration:
#   CLOUSEAU_URL

ping = require "clouseau-js"

module.exports = (robot) ->
  robot.respond /clouseau$/i, (msg) ->
    load = ping.addCheckpoint('OK BUDDY!', 60000);
    widget = ping.addCheckpoint('RENDERED', 20000);

    ping.start(process.env.CLOUSEAU_URL)
      .then(load)
      .then(widget)
      .then((-> msg.send 'Hullo guys!'), (-> msg.send 'Help me, I\'m sick, I don\'t wanna go to school'))

