ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])


require 'java' unless ENV['RUBY_ENV']=='no-java'
require 'logger'
require "faye"
require "redis"
require "resque"
require "thin"
require "honeybadger"
require "active_support"



Faye::WebSocket.load_adapter('thin')
$app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
LOGGER = Logger.new('log/faye.log')

=begin
:handshake [client_id] – Triggered when a new client connects and is issued with an ID.
:subscribe [client_id, channel] – Triggered when a client subscribes to a channel. This does not fire if a /meta/subscribe message is received for a subscription that already exists.
:unsubscribe [client_id, channel] – Triggered when a client unsubscribes from a channel. This can fire either because the client explicitly sent a /meta/unsubscribe message, or because its session was timed out by the server.
:publish [client_id, channel, data] – Triggered when a non-/meta/** message is published. Includes the client ID of the publisher (which may be nil), the channel the message was sent to and the data payload.
:disconnect [client_id] – Triggered when a client session ends, either because it explicitly sent a /meta/disconnect message or because its session was timed out by the server.
=end
def channel_to_constant(channel)
	channel.camelize.constantize
end

def handle_request(action, channel, client_id, params = {})
	$client ||= Faye::Client.new('http://localhost:9292/faye') # init this here if we dont have one
	begin
		require channel[1..-1]
	rescue => e
		puts e.message
		puts e.backtrace
		return
	end
	LOGGER.info "Handling action #{action} for controller #{channel}"
	controller = channel_to_constant(channel) rescue nil
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

autoload :Client, 'client'

$app.bind(:publish)     {|cid, chnl, data| handle_request(:publish, chnl, cid, data) }
$app.bind(:subscribe)   {|cid, chnl|       handle_request(:subscribe, chnl, cid) }
$app.bind(:unsubscribe) {|cid, chnl|       handle_request(:unsubscribe, chnl, cid) }

