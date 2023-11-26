require './lib/token'
require './lib/server'
require './lib/object_storage_container'

token = Token.new

puts "起動中のサーバー台数: #{Server.count(token: token)}"
puts "オブジェクトストレージのコンテナ情報: #{ObjectStorageContainer.containers_info(token: token)}"

container = ObjectStorageContainer.new(token: token, container_name: 'test', new: false)

puts "#{container.container_name}のオブジェクト一覧: #{container.get_container_objects_info}"

# container.put_object(file_name: 'sample2.txt')
# p container.get_object(object_name: 'sample2.txt')

# container.delete_object(object_name: 'sample2.txt')

# container.put_object(file_name: 'chiku_mine_ftb_uni.zip')

# puts "#{container.container_name}のオブジェクト一覧: #{container.get_container_objects_info}"

# File.write('./chiku_mine_ftb_uni_after.zip', container.get_object(object_name: 'chiku_mine_ftb_uni.zip'))

puts "#{container.container_name}のオブジェクト一覧: #{container.get_container_objects_info}"

puts "オブジェクトストレージのコンテナ情報: #{ObjectStorageContainer.containers_info(token: token)}"

# container2 = ObjectStorageContainer.new(token: token, container_name: 'test', new: false)
# container2.delete_container(with_objects: true)

puts "オブジェクトストレージのコンテナ情報: #{ObjectStorageContainer.containers_info(token: token)}"
