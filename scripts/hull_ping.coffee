# Description:
#   Allows to check that an app behaves as expected by sending messages from PhantomJS
#   Useful for integration testing
#
# Dependencies:
#   "clouseau" : "0.2.0"
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


_do = (msg, debug=false) ->
  load = clouseau.addCheckpoint(alertCheck('OK BUDDY!'), 60000, 'Hull.init called')
  msg.send "Loaded" if debug
  widget = clouseau.addCheckpoint(alertCheck('RENDERED'), 20000, 'Widget rendered')
  msg.send "Widgetized" if debug
  clouseau.start(process.env.CLOUSEAU_URL||"http://hull-js.s3.amazonaws.com/__ping/index.html").then ()->
    msg.send "Start Loaded (oh yeah)" if debug
    load
    msg.send "End Loaded" if debug
  .then ()->
    msg.send "Start Widget" if debug
    widget
    msg.send "End Widget" if debug

module.exports = (robot) ->
  robot.respond /clouseau$/i, (msg) ->
    msg.send "Pinging #{process.env.CLOUSEAU_URL}"
    _do(msg, false).then((-> msg.send 'Hullo guys!'), ((err)-> msg.send "D'oooohh: #{err}"))

  robot.respond /clouseau debug$/i, (msg) ->
    msg.send "Pinging #{process.env.CLOUSEAU_URL}"
    _do(msg, true).then((-> msg.send 'Hullo guys!'), ((err)-> msg.send "D'oooohh: #{err}"))

  robot.router.get "/clouseau", (req, res) ->
    _do().then((-> res.end 'OK'), ((err)-> res.end 'NOK: ' + err))
