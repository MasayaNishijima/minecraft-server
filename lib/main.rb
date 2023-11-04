require './lib/token'
require './lib/server'

token = Token.new

puts "起動中のサーバー台数: #{Server.count(token: token)}"
