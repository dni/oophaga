App = require "./components/backend/app"

server = App (port)->
  console.log "Welcome to Oophaga CMS, quack! server runs on port #{port}"

