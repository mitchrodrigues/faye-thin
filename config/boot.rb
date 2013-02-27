require 'rubygems'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
require 'logger'

require 'bjson'
require "faye"
require "redis"
require "resque"
require "thin"
require "honeybadger"
require "active_support"
require "mongo"
require "mongoid"
require 'pathname'
require 'active_model'

initializers = Dir.glob("#{SERVER_ROOT}/config/initializers/**/*.rb")
initializers.each do |initializer|
   require "initializers/#{File.basename(initializer, ".rb")}"
end

Faye::WebSocket.load_adapter('thin')
$app = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25)
LOGGER = Logger.new('log/faye.log')

AUTO_LOAD_PATHS.each do |folder|
  path = "#{SERVER_ROOT}/#{folder}/"
  $:.unshift(path) unless $:.include?(path)
  Dir.glob("#{path}**/*.rb").each do |lib_file|
    lib = lib_file.gsub(path, "").gsub(".rb", "")
    require lib
    #autoload lib.camelcase.to_sym, lib
  end
end

$app.bind(:publish)     {|cid, chnl, data| Server.handle_request(:publish, chnl, cid, data) }
$app.bind(:subscribe)   {|cid, chnl|       Server.handle_request(:subscribe, chnl, cid) }
$app.bind(:unsubscribe) {|cid, chnl|       Server.handle_request(:unsubscribe, chnl, cid) }