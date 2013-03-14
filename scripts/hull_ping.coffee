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

clouseau = require "clouseau-js"

_do = () ->
  load = clouseau.addCheckpoint('OK BUDDY!', 60000);
  widget = clouseau.addCheckpoint('RENDERED', 20000);

  clouseau.start(process.env.CLOUSEAU_URL).then(load).then(widget)


module.exports = (robot) ->
  robot.respond /clouseau$/i, (msg) ->
    _do().then((-> msg.send 'Hullo guys!'), ((err)-> msg.send 'Help me, I\'m sick, I don\'t wanna go to school: ' + err))

  robot.router.get "/clouseau", (req, res) ->
    _do().then((-> res.end 'OK'), ((err)-> res.end 'NOK: ' + err))
