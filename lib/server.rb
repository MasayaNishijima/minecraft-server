require 'net/http'
require 'json'

# VPSサーバーの情報取得・制御するためのクラス
class Server
  PLAN =  "c8ce932a-a7de-4fbb-ab64-903826082be3" # g2l-t-c6m8のidを指定

  def initialize(token:, server_name:, new: false)
    @token = token
    @server_name = server_name
    create_server if new

    @server_id = self.class.servers_info(token: token).find { |server| server['metadata']['instance_name_tag'] == @server_name }['id']
  end

  def self.count(token:)
    servers_info(token: token).count
  end

  def self.servers_info(token:)
    uri = URI.parse('https://compute.c3j1.conoha.io/v2.1/servers/detail')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.to_s }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get server info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)['servers']
  end

  def self.plans(token:)
    uri = URI.parse('https://compute.c3j1.conoha.io/v2.1/flavors/detail')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.to_s }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get plans info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)['flavors']
  end

  private

  def create_server # rubocop:disable Metrics/MethodLength
    boot_storage = Volume::BootStorage.new(token: @token, volume_name: "#{@server_name}_BOOT_STORAGE", new: true)
    uri = URI.parse('https://compute.c3j1.conoha.io/v2.1/servers')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    params = {
      server: {
        flavorRef: PLAN,
        adminPass: 'passwordAAAA456312!!',
        block_device_mapping_v2: [
          {
            uuid: boot_storage.volume_id
          }
        ],
        metadata: {
          'instance_name_tag' => @server_name
        }
      }
    }
    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.to_s }

    response = https.post(uri.path, params.to_json, headers)

    p response.body
    raise StandardError, "failed to create server. response code: #{response.code}" unless response.code == '202'
  end
end
