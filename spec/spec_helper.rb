$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rallytastic'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end


Mongoid.configure do |config|
  name = "rallytastic_test"
  host = "localhost"
  config.master = Mongo::Connection.new.db(name)
  config.persist_in_safe_mode = false
end
