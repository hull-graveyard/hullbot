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

logger = null

renderAlert = (page) ->
  # @ == Q.defer()
  page.onAlert (txt)->
    @reject new Error("Unexpected message: #{txt}") unless txt == 'RENDERED'
    @resolve(page)

initAlert = (page) ->
  # @ == Q.defer()
  page.onAlert (txt)->
    @reject new Error("Unexpected message: #{txt}") unless txt == 'OK BUDDY!'
    @resolve(page)



_do = () ->
  load = clouseau.addCheckpoint(initAlert, 60000);
  widget = clouseau.addCheckpoint(renderAlert, 20000);

  clouseau.start(process.env.CLOUSEAU_URL).then(load).then(widget)


module.exports = (robot) ->
  robot.respond /clouseau$/i, (msg) ->
    _do().then((-> msg.send 'Hullo guys!'), ((err)-> msg.send "D'oooohh: #{err}"))

  robot.router.get "/clouseau", (req, res) ->
    _do().then((-> res.end 'OK'), ((err)-> res.end 'NOK: ' + err))
