module Users
	class Online
		def subscribe

		end

		def publish
		  client_object = Client.new(@client, @params)
		  Client.add(@client, client_object)
		  LOGGER.info "Client Connected: #{@client}"
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