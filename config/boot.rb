ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)



require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require 'logger'
require "faye"
require "redis"
require "resque"
require "thin"
require "honeybadger"
require "active_support"
require "neography"

initializers = Dir.glob("#{SERVER_ROOT}/config/initializers/*.rb")
initializers.each do |initializer|
   require "initializers/" + File.basename(initializer, File.extname(initializer))
end

Faye::WebSocket.load_adapter('thin')
$app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
LOGGER = Logger.new('log/faye.log')

libs = Dir.glob("#{SERVER_ROOT}/lib/**/*.rb")
libs.each do |l|
  auto_load_lib = l.gsub!("#{SERVER_ROOT}/lib/", "").gsub(".rb", "")
  autoload auto_load_lib.camelcase.to_sym, auto_load_lib
end

$app.bind(:publish)     {|cid, chnl, data| Server.handle_request(:publish, chnl, cid, data) }
$app.bind(:subscribe)   {|cid, chnl|       Server.handle_request(:subscribe, chnl, cid) }
$app.bind(:unsubscribe) {|cid, chnl|       Server.handle_request(:unsubscribe, chnl, cid) }

