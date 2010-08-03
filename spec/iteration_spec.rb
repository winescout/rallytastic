require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Iteration do 
  before do 
    Iteration.collection.remove
    @hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'iteration.txt'))
    RallyAPI.stub!(:get).and_return(eval(@hash_vals))
  end
  

  it "should be a iteration" do 
    Iteration.new.class.should == Iteration
  end
  
  describe "#associate" do 
    before do 
      @iteration = Iteration.new(:rally_uri => "http://testuri.com")
    end

    it "should associate project" do 
      @iteration.associate(eval(@hash_vals))
      @iteration.project.should_not be_nil
    end
  end

  describe "refreshing" do 
    before do 
      @iteration = Iteration.new(:rally_uri => "http://testuri.com")
    end
    it "should assign name" do 
      @iteration.refresh
      @iteration.name.should == "Iteration1"
    end

    it "should assign created_on" do 
      @iteration.refresh
      @iteration.created_on.should == Date.parse("Jul 13, 2009")
    end

    it "should assign end_date" do 
      @iteration.refresh
      @iteration.end_date.should == Date.parse("2009-07-18T23:59:59.000Z")
    end
    
    it "should assign notes" do 
        @iteration.refresh
        @iteration.name.should == "Iteration1"
    end

    it "should assign resources"  do 
      @iteration.refresh
      @iteration.resources.should == "2.0"
    end

    it "should assign start_date" do 
      @iteration.refresh
      @iteration.start_date.should == Date.parse("2009-07-13T00:00:00.000Z")
    end

    it "should assign state" do 
      @iteration.refresh
      @iteration.state.should == "Planning"
    end

    it "should assign theme" do 
      @iteration.refresh
      @iteration.theme.should == "This is the theme"
    end

    #it "should assign user_iteration_capacities" do 
    #  @iteration.refresh
    #  @iteration.user_iteration_capacities.should == "Iteration1"
    #end
  end

end
