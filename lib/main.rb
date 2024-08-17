require './lib/token'
require './lib/server'
require './lib/object_storage_container'
require './lib/image'
require './lib/volume'
require './lib/volume/bootstorage'

token = Token.new

puts "起動中のサーバー台数: #{Server.count(token: token)}"
puts "オブジェクトストレージのコンテナ情報: #{ObjectStorageContainer.containers_info(token: token)}"
p Image.images_name_and_id(token: token)

# container = ObjectStorageContainer.new(token: token, container_name: 'test', new: false)
# puts "#{container.container_name}のオブジェクト一覧: #{container.get_container_objects_info}"

# puts "ボリュームの個数: #{Volume.count(token: token)}"
# Volume::BootStorage.new(token: token, volume_name: 'test', new: true)
# sleep 10
# puts "ボリュームの個数: #{Volume.count(token: token)}"
# volume = Volume.new(token: token, volume_name: 'test')
# volume.delete
# puts "ボリュームの個数: #{Volume.count(token: token)}"
