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
net = require 'net'


#=========================
# Server Definition
#=========================
reflect = (socket) ->
  socket.pipe socket


#=========================
# Launch Server
#=========================
net.createServer(reflect).listen(23)
console.log "================================================="
console.log ' The server is online and listening on Port 23.'
console.log "================================================="
