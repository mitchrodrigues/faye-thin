#config.ru
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

$0 = "Taazoo App: Feeds"


SERVER_ROOT = Dir.pwd
AUTO_LOAD_PATHS = [
  "lib", "app/controllers", "app/models"
]


$LOAD_PATH.unshift( File.join( Dir.pwd, 'config' ) )


require 'boot'
$0 = "Taazoo App: Feeds"
run $app
