require 'net/http'
require 'json'

# ボリュームの情報取得・制御するためのクラス()
class Volume
  def initialize(token:, volume_name:, new: false)
    @token = token
    @volume_name = volume_name
    create_volume if new
    @volume_id = self.class.volumes_info(token: token).find { |volume| volume['name'] == volume_name }['id']
  end

  def self.count(token:)
    volumes_info(token: token).count
  end

  def self.volumes_info(token:)
    uri = URI.parse("https://block-storage.c3j1.conoha.io/v3/#{token.tenant_id}/volumes")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.to_s }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get volume info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)['volumes']
  end

  def delete
    url = URI.parse("https://block-storage.c3j1.conoha.io/v3/#{@token.tenant_id}/volumes/#{@volume_id}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.to_s }

    response = https.delete(url.path, headers)

    raise StandardError, "failed to delete volume. response code: #{response.code}" unless response.code == '202'
  end

  private

  def create_volume
    uri = URI.parse("https://block-storage.c3j1.conoha.io/v3/#{@token.tenant_id}/volumes")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    params = {
      volume: {
        size: @size,
        description: 'null',
        name: @volume_name,
        volume_type: @volume_type,
        imageRef: @image
      }
    }
    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.to_s }

    response = https.post(uri.path, params.to_json, headers)

    raise StandardError, "failed to put container. response code: #{response.code}" unless response.code == '202'
  end
end
