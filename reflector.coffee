#===============================================================================
# CoreOS - Reflector Demo
#===============================================================================
# This server is part of the CoreOS + Docker tutorial from PandaStrike.  The
# tutorial is meant to demo deployment basics.  So, what follows is basically the
# "Hello World" equivalent of Node.  Any requests sent to this server are
# reflected back in the reponse.

# For the sake of explicit clarity, the components of the server are demarcated
# below.  However, this server can be written in a single line as:

# ((require "net").createServer ((socket) -> socket.pipe socket)).listen 80


#=========================
# Modules
#=========================
http = require 'http'
url = require 'url'

#=========================
# Server Definition
#=========================
reflect = (req, res) ->
  res.writeHeader 200, {"Content-Type": "text/plain"}
  res.write "Hi there.  I've received your request loud and clear.  I've
        reflected it back to you here: \n"


  res.write '======================' + '\n'
  res.write "Host: " + req.headers.host + '\n'
  res.write "Accept: " + req.headers.accept + '\n'
  res.write "httpVersion: " + req.httpVersion + '\n'
  res.write "Method: " + req.method + '\n'
  res.write "URL: " + req.url + '\n'
  res.write '======================' + '\n'
  res.write '\n'
  res.end()


#=========================
# Launch Server
#=========================
http.createServer(reflect).listen(80)
console.log "================================================="
console.log ' The server is online and listening on Port 80.'
console.log "================================================="
