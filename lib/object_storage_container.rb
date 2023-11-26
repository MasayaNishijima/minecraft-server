class ObjectStorageContainer
	attr_reader :container_name

	def initialize(token:, container_name:, new: false)
		@token = token
		@container_name = container_name
		create_container if new
	end

	def self.containers_info(token:)
		uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{token.tenant_id}")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    headers = { 'Accept' => 'application/json', 'X-Auth-Token' => token.id }

  	response = https.get(uri.path, headers)
    raise StandardError, "failed to get containers info. response code: #{response.code}" unless response.code == '200'

    JSON.parse(response.body)
	end


	def get_container_objects_info
		uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}")
		https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

		headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

		response = https.get(uri.path, headers)
    raise StandardError, "failed to get container. response code: #{response.code}" unless response.code == '200'

		JSON.parse(response.body)
	end

	def put_object(directory: '.', file_name:, object_name: file_name)
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

	def get_object(object_name:)
		uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}/#{object_name}")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true

		headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

		response = https.get(uri.path, headers)

		raise StandardError, "failed to get object. response code: #{response.code}" unless response.code == '200'

		response.body
	end

	def delete_object(object_name:)
		uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}/#{object_name}")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true

		headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

		response = https.delete(uri.path, headers)

		raise StandardError, "failed to delete object. response code: #{response.code}" unless response.code == '204'
	end

	def delete_container()
		# curl -i -X DELETE \
		# -H "Accept: application/json" \
		# -H "X-Auth-Token: 2c6f2de2126a4102b38368c32e7043db" \
		# https://object-storage.tyo1.conoha.io/v1/nc_cc54f7476b8e444bad238a943a94ccdf/container

		uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}")
		https = Net::HTTP.new(uri.host, uri.port)
		https.use_ssl = true

		headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

		response = https.delete(uri.path, headers)

		raise StandardError, "failed to delete container. response code: #{response.code}" unless response.code == '204'
	end

	private

	def create_container
		uri = URI.parse("https://object-storage.tyo1.conoha.io/v1/nc_#{@token.tenant_id}/#{@container_name}")
		https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

		headers = { 'Accept' => 'application/json', 'X-Auth-Token' => @token.id }

		response = https.put(uri.path, nil, headers)
    raise StandardError, "failed to put container. response code: #{response.code}" unless response.code == '201'
	end
end
