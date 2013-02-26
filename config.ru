#config.ru
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

$0 = "Taazoo App: Feeds"

SERVER_ROOT = Dir.pwd

$LOAD_PATH.unshift( File.join( Dir.pwd, 'lib' ) )
$LOAD_PATH.unshift( File.join( Dir.pwd, 'config' ) )
$LOAD_PATH.unshift( File.join( Dir.pwd, 'app', 'controllers' ) )

@app_dir = File.join( Dir.pwd, 'app')
Dir.entries(@app_dir).each do |entry|
  next if entry['.']
  path = File.join(@app_dir, entry)
  $:.unshift(path) if File.directory?(path) && !$:.include?(path)
end

require 'boot'

run $app
