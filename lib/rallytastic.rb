# Set up gems listed in the Gemfile.
gemfile = File.expand_path('../Gemfile', __FILE__)

begin
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
rescue Bundler::GemNotFound => e
  STDERR.puts e.message
  STDERR.puts "Try running `bundle install`."
  exit!
end if File.exist?(gemfile)


lib = File.dirname(__FILE__)
require 'mongoid'
require 'rest_client'
require File.join(lib, 'rally/parsing_helpers.rb')
require File.join(lib, 'story.rb')
require File.join(lib, 'project.rb')
require File.join(lib, 'iteration.rb')
require File.join(lib, 'revision_history.rb')
require File.join(lib, 'revision.rb')
require File.join(lib, 'rally/rally_api.rb')
require File.join(lib, 'parsers/base.rb')
require File.join(lib, 'parsers/madison.rb')


#temp for rally and mongoid setup
require '~/rally_config'
