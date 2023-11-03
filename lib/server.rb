require 'net/http'
require 'json'

class Server
  def self.count(token:)
    servers_info(token: token).count
  end

  def self.servers_info(token:)
    uri = URI.parse("https://compute.tyo1.conoha.io/v2/#{token.tenant_id}/servers")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.id }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get server info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)['servers']
  end
end
