# minecraft-server

# サンプルコード
## オブジェクトストレージ
```ruby
require './lib/token'
require './lib/object_storage_container'

CONTAINER_NAME  = 'test'

token = Token.new


container = ObjectStorageContainer.new(token: token, container_name: CONTAINER_NAME, new: true)
puts "オブジェクトストレージのコンテナ情報: #{ObjectStorageContainer.containers_info(token: token)}"


container.put_object(directory: 'tmp', file_name: 'sample.txt')
puts "#{container.container_name}のオブジェクト一覧: #{container.get_container_objects_info}"


container.get_object(object_name: 'sample.txt')
container.delete_object(object_name: 'sample.txt')

container.delete_container(with_objects: true)
