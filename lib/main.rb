require './lib/token'
require './lib/server'

token = Token.new

p Server.count(token: token)
