require 'net/http'
require 'json'

# ボリュームの情報取得・制御するためのクラス()
class Image
  def initialize(token:)
    @token = token
  end

  def self.images_info(token:)
    uri = URI.parse('https://image-service.c3j1.conoha.io/v2/images')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.to_s }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get images info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)['images']
  end

  def self.images_name_and_id(token:)
    images_info(token: token).map { |image| [image['name'], image['id']] }
  end
end
