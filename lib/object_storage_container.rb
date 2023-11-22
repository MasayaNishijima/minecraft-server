class ObjectStorageContainer
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
