require 'dotenv'
require 'net/http'
require 'json'

class Token
  Dotenv.load

  def initialize
    @token = get_token
  end

  def id
    @token['id']
  end

  def tenant_id
    @token['tenant']['id']
  end

  private

  def get_token
    uri = URI.parse('https://identity.c3j1.conoha.io/v3/auth/tokens')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    parms = { 'auth' => {
      'passwordCredentials' => { 'username' => ENV['CONOHA_API_USER_ID'],
                                 'password' => ENV['CONOHA_API_USER_PASSWORD'] },
      'tenantId' => ENV['CONOHA_API_TENANT_ID']
    } }
    headers = { 'Accept' => 'application/json' }

    response = https.post(uri.path, parms.to_json, headers)

    raise StandardError, "failed to get token. response code: #{response.code}" unless response.code == '200'

    json = JSON.parse(response.body)
    json['access']['token']
  end
end

{ auth: {
  identity: { methods: ['password'],
              password: { user: { id: ENV['CONOHA_API_USER_ID'],
                                  password: ENV['CONOHA_API_USER_PASSWORD'] } } }, scope: { project: { id: ENV['CONOHA_API_TENANT_ID'] } }
} }
