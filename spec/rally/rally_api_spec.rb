require File.join(File.dirname(__FILE__), '..', 'spec_helper')

class MockResource
  attr_accessor :rally_id, :rally_uri

  def self.rally_uri
    "/fake_resource.js"
  end

  def rally_uri
    self.rally_uri
  end
end

describe RallyAPI do 
  before(:all) do 
    RallyAPI::configure do |config|
      config.user = "test_user"
      config.password = "test_password"
    end
  end

  before(:each) do 
    RallyAPI.stub(:do_get).and_return("{}")
  end
  
  describe "#all" do 
    it "should pass endpoint" do 
      RallyAPI.should_receive(:do_get).with("/fake_resource.js",anything())
      RallyAPI.all(MockResource, :conditions => {:name => "Fred"})
    end

    it "should set query part of complex query" do 
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:query => '( Name = "Fred" )'))
      RallyAPI.all(MockResource, :start => 20, :conditions => {:name => "Fred"})
    end

    it "should set start part of complex query" do 
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:start => 20))
      RallyAPI.all(MockResource, :start => 20, :conditions => {:name => "Fred"})
    end

    it "should set start" do 
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:start => 20))
      RallyAPI.all(MockResource, :start => 20)
    end

    it "should set pagesize" do 
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:pagesize => 20))
      RallyAPI.all(MockResource, :pagesize => 20)
    end

    it "should accept an equality match" do
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:query => '( Name = "Fred" )'))
      RallyAPI.all(MockResource, :conditions => {:name => "Fred"})
    end

    it "should accept > match" do
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:query => '( Count > "1" )'))
      RallyAPI.all(MockResource, :conditions => {:count.gt => 1})
    end

    it "should accept >= match" do 
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:query => '( Count >= "1" )'))
      RallyAPI.all(MockResource, :conditions => {:count.gte => 1})
    end

    it "should accept < match" do
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:query => '( Count < "1" )'))
      RallyAPI.all(MockResource, :conditions => {:count.lt => 1})
    end

    it "should accept =< match" do
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:query => '( Count <= "1" )'))
      RallyAPI.all(MockResource, :conditions => {:count.lte => 1})
    end

    it "should accept != match" do 
      RallyAPI.should_receive(:do_get).with(anything(), hash_including(:query => '( Count != "1" )'))
      RallyAPI.all(MockResource, :conditions => {:count.ne => 1})
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
