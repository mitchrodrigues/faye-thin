

class Server

  class << self
    def channel_to_constant(channel)
      channel.camelize.constantize
    end

    def handle_request(action, channel, client_id, params = {})
      $client ||= Faye::Client.new('http://localhost:9292/faye') # init this here if we dont have one
      # begin
      #   require channel[1..-1]
      # rescue => e
      #   puts e.message
      #   puts e.backtrace
      #   return
      # end
      LOGGER.info "Handling action #{action} for controller #{channel}"
      controller = channel_to_constant(channel)
      if (controller)
        LOGGER.info "Proccessing: #{controller}"
        LOGGER.info "Params: #{params.inspect}"
        LOGGER.info "Client: #{client_id}"


        kls = controller.new
        kls.instance_variable_set(:@params, params)
        kls.instance_variable_set(:@client, client_id)
        kls.instance_variable_set(:@publisher, $app.get_client || $client)
        if kls.respond_to?(action.to_sym)
          begin
            kls.send(action)
          rescue => e
            LOGGER.error e.message
            LOGGER.error e.backtrace.join("\n")
          end
        else
          LOGGER.error "No method defined for #{action} in #{controller}"
        end
      end
    end
  end
end
