require './lib/token'
require './lib/server'
require './lib/object_storage_container'

token = Token.new

puts "起動中のサーバー台数: #{Server.count(token: token)}"
puts "オブジェクトストレージのコンテナ情報: #{ObjectStorageContainer.containers_info(token: token)}"

# container = ObjectStorageContainer.new(token: token, container_name: 'test', new: false)
# puts "#{container.container_name}のオブジェクト一覧: #{container.get_container_objects_info}"

