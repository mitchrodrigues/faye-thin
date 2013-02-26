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
				:count   => Client.count,
				:data    => [client_object.data]
		  })
		end

		def unsubscribe
			Client.delete(@client)
			@publisher.publish('/users/list', {
				:channel => @channel,
				:client  => @client,
				:message => 'Disconnect',
				:count   => Client.count,
				:data    => {
					:client => @client
				}
		  })
		end
	end
end