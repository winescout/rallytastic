require File.join(File.dirname(__FILE__), 'spec_helper')

class MockResource
  attr_accessor :rally_id, :rally_uri
  def rally_uri
    "http://fake_resource"
  end
end

describe RallyAPI do 
  before(:all) do 
    RallyAPI::configure do |config|
      config.user = "test_user"
      config.password = "test_password"
    end
  end

  describe "configuration" do 
    before(:each) do 
      @mock_resource = MockResource.new
    end
    it "should set password" do 
      RallyAPI::configuration.password.should == "test_password"
    end

    it "should set user" do 
      RallyAPI::configuration.user.should == "test_user"
    end

    it "should degrade gracefully without password" do 
      RallyAPI::configuration.user = nil
      lambda{RallyAPI.get @mock_resource}.should raise_error RallyAPI::CredentialsError
    end

    it "should degrade gracefully without password" do 
      RallyAPI::configuration.password = nil
      lambda{RallyAPI.get @mock_resource}.should raise_error RallyAPI::CredentialsError
    end

  end
  
  
end
