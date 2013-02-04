class Client
	class << self
		@@list = {}
		def add(key, client)
			@@list[key] = client
			puts "New client connected"
		end
		def delete(key)
			@@list.delete key
			puts "Client disconnected connected"
		end

		def get_list
			results = @@list.collect(&:data)
			puts "Results: " + results
			results
		end
	end

	attr_accessor :data, :id
	def initialize(client, data)
		@data = data
		@id = client
	end
end