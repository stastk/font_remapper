require 'bundler'
Bundler.require
require './app'

require 'sass/plugin/rack'
Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

run Remapper