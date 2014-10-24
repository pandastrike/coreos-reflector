#===============================================================================
# CoreOS - Reflector Demo
#===============================================================================
# This server part of the CoreOS-Reflector sample project.  It is meant to demo
# deployment basics and is the "Hello World" equivalent in Node.  Any requests sent
# to this server are reflected back in the reponse.

#=========================
# Modules
#=========================
http = require 'http'
url = require 'url'


#=========================
# Server Definition
#=========================
reflector = (req, res) ->
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
http.createServer(reflector).listen(80)
console.log 'The server is online and listening on Port 80.'
