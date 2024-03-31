require 'net/http'
require 'json'

# VPSサーバーの情報取得・制御するためのクラス
class Server
  def self.count(token:)
    servers_info(token: token).count
  end

  def self.servers_info(token:)
    uri = URI.parse('https://compute.c3j1.conoha.io/v2.1/servers')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.to_s }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get server info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)['servers']
  end
end
