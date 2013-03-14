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

# Expects for a certain text to be displayed through an `alert()` call in the page
alertCheck = (expectedMessage)->
  (page)->
    page.onAlert = (txt)=>
      @reject new Error("Unexpected message: #{txt}") unless txt == expectedMessage
      @resolve(page)


_do = () ->
  load = clouseau.addCheckpoint(alertCheck('OK BUDDY!'), 60000, 'Hull.init called')
  widget = clouseau.addCheckpoint(alertCheck('RENDERED'), 20000, 'Widget rendered')
  clouseau.start(process.env.CLOUSEAU_URL).then(load).then(widget)

module.exports = (robot) ->
  robot.respond /clouseau$/i, (msg) ->
    _do().then((-> msg.send 'Hullo guys!'), ((err)-> msg.send "D'oooohh: #{err}"))

  robot.router.get "/clouseau", (req, res) ->
    _do().then((-> res.end 'OK'), ((err)-> res.end 'NOK: ' + err))
