#config.ru
# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])


puts File.join(Dir.pwd, 'lib')

$LOAD_PATH.unshift( File.join( Dir.pwd, 'lib' ) )
$LOAD_PATH.unshift( File.join( Dir.pwd, 'config' ) )
$LOAD_PATH.unshift( File.join( Dir.pwd, 'controllers' ) )
require 'boot'

run $app