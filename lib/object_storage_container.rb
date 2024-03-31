# オブジェクトストレージを操作するためのクラス。
# コンテナ単位でインスタンスを使用するように設計
class ObjectStorageContainer
  # コンテナ名を示す文字列インスタンス変数(コンテナの詳細情報はインスタンスには保持しない)
  attr_reader :container_name

  # new引数がtrueの場合、コンテナを新規作成する。
  def initialize(token:, container_name:, new: false)
    @token = token
    @container_name = container_name
    create_container if new
  end

  # オブジェクトストレージのコンテナ情報を取得する。
  def self.containers_info(token:)
    uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{token.tenant_id}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.id }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get containers info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)
  end

  # コンテナ内のオブジェクト情報を取得する。
  def get_container_objects_info
    uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

    response = https.get(uri.path, headers)
    raise StandardError, "failed to get container. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)
  end

  # コンテナにオブジェクトをアップロードする。(ファイル名と別のオブジェクト名を指定する場合は、object_name引数にオブジェクト名を指定する)
  def put_object(file_name:, directory: '.', object_name: file_name)
    uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}/#{object_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

    https.start do |https|
      request = Net::HTTP::Put.new(uri.path, headers)
      File.open("#{directory}/#{file_name}", 'rb') do |file|
        request.body_stream = file
        request.content_length = file.size
        response = https.request(request)
        raise StandardError, "failed to put object. response code: #{response.code}" unless response.code == '201'
      end
    end
  end

  # コンテナ内のオブジェクトを取得してファイルに保存する。(ファイル名と別のオブジェクト名を指定する場合は、file_name引数にファイル名を指定する)
  def get_object(object_name:, directory: '.', file_name: object_name)
    uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}/#{object_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

    https.start do |https|
      request = Net::HTTP::Get.new(uri.path, headers)
      https.request(request) do |response|
        File.open("#{directory}/#{file_name}", 'wb') do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
        raise StandardError, "failed to get object. response code: #{response.code}" unless response.code == '200'
      end
    end
  end

  # コンテナ内のオブジェクトを削除する。
  def delete_object(object_name:)
    uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}/#{object_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

    response = https.delete(uri.path, headers)

    raise StandardError, "failed to delete object. response code: #{response.code}" unless response.code == '204'
  end

  # コンテナを削除する。(with_objects引数がtrueの場合、コンテナにオブジェクトが存在する場合も削除を実行する)
  def delete_container(with_objects: false)
    # コンテナ内のオブジェクトを削除する処理(with_objects引数がtrueの場合のみ実行)
    get_container_objects_info.each { |object| delete_object(object_name: object['name']) } if with_objects

    uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

    response = https.delete(uri.path, headers)

    raise StandardError, "failed to delete container. response code: #{response.code}" unless response.code == '204'
  end

  private

  # コンテナを新規作成する。
  def create_container
    uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

    response = https.put(uri.path, nil, headers)
    raise StandardError, "failed to put container. response code: #{response.code}" unless response.code == '201'
  end
end
