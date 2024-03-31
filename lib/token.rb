require 'dotenv'
require 'net/http'
require 'json'

# APIへアクセスするためのトークンを取得・管理するためのクラス
class Token
  Dotenv.load

  def initialize
    @token = get_token
  end

  def to_s
    @token
  end

  def tenant_id
    ENV['CONOHA_API_TENANT_ID']
  end

  private

  def get_token
    uri = URI.parse('https://identity.c3j1.conoha.io/v3/auth/tokens')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    prams = { auth: {
      identity: { methods: ['password'],
                  password: { user: { id: ENV['CONOHA_API_USER_ID'],
                                      password: ENV['CONOHA_API_USER_PASSWORD'] } } }, scope: { project: { id: tenant_id } } # rubocop:disable Layout/LineLength
    } }
    headers = { 'Accept' => 'application/json' }

    response = https.post(uri.path, prams.to_json, headers)

    raise StandardError, "failed to get token. response code: #{response.code}" unless response.code == '201'

    response.header['X-Subject-Token']
  end
end
