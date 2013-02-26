module Users
	class List
		# +fayeAdapter.bind('subscribe', function(clientId, channel) {
		# +  switch (channel) {
		# +    case '/users/list':
		# +      var currentList = users.getUsers();
		# +      client.publish('/users/list', {
		# +          channel  :  channel,
		# +          client   :  clientId,
		# +          data     : currentList
		# +      });
		# +      break;
		# +    default:
		# +      break;
		# +  }

		def subscribe
			begin
			@publisher.publish('/users/list', {
				:channel => @channel,
				:client  => @client,
				:data    => Client.get_list,
				:message => "Connect",
				:count   => Client.count
			})
			rescue => e
				LOGGER.info e.message
				LOGGER.info e.backtrace.join("\n")
			end
		end
	end
end
