require 'dotenv'
Dotenv.load

require 'net/http'
require 'json'

uri = URI.parse('https://identity.tyo1.conoha.io/v2.0/tokens')
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true

parms = { 'auth' => {
  'passwordCredentials' => { 'username' => ENV['CONOHA_API_USER_ID'],
                             'password' => ENV['CONOHA_API_USER_PASSWORD'] },
  'tenantId' => ENV['CONOHA_API_TENANT_ID']
} }
headers = { "Accept" => "application/json" }

response = https.post(uri.path, parms.to_json, headers)

p response
p response.body
