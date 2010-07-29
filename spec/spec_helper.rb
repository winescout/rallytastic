$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rallytastic'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

MongoMapper.database = 'rallytastic_test'
