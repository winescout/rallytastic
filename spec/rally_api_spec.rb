require File.join(File.dirname(__FILE__), 'spec_helper')

class MockResource
  attr_accessor :rally_id, :rally_uri
end

describe RallyAPI do 
  before do 
    @resource = MockResource.new
  end
end
