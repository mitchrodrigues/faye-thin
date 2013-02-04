module Users
	class Online
		def subscribe

		end

		def publish
		  client_object = Client.new(@client, @params)
		  Client.add(@client, client_object)

		  puts "#{@params.inspect}"
		  LOGGER.info "Client Connected: #{client_object.inspect}}"

		  @publisher.publish('/users/list', {
		  	:channel => @channel,
		  	:client  => @client,
		  	:message => 'Connect',
		  	:data    => [client_object.data]
		  })
		end

		def unsubscribe
			Client.delete(@client)
		end
	end
end