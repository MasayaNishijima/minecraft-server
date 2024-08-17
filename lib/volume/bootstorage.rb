require 'net/http'
require 'json'
require './lib/volume'

# ブートストレージを管理するためのクラス(100GB用)
class Volume::BootStorage < Volume
  IMAGE = '30139c65-2650-47df-8c8f-23feb5287a48' # 'vmi-ubuntu-24.04-amd64'のidを指定
  def initialize(token:, volume_name:, new: false)
    @image = Volume::BootStorage::IMAGE
    @size = 100

    super(token: token, volume_name: volume_name, new: new)
  end
end
