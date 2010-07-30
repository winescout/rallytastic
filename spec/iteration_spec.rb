require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Iteration do 
  before do 
    Iteration.collection.remove
    hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'iteration.txt'))
    RallyAPI.stub!(:get).and_return(eval(hash_vals))
  end


  describe "stories" do
    before do 
      Iteration.collection.remove
      Story.collection.remove
      story_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'story.txt'))
      RallyAPI.stub!(:get).and_return(eval(story_vals))
      @iteration = Iteration.new(:rally_id => "462353428")
      query_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'story_query.txt'))
      RallyAPI.stub!(:query).and_return(eval(query_vals))
    end
    
    it "should have list of stories" do 
      @iteration.stories.should_not be_nil
    end    
    
    it "should refresh stories" do 
      @iteration.refresh_stories
      @iteration.stories.size.should > 0
    end
  end
  

  it "should be a iteration" do 
    Iteration.new.class.should == Iteration
  end
  

  describe "refreshing" do 
    before do 
      @iteration = Iteration.new(:rally_id => "462353428")
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

    it "should assign project_uri" do 
      @iteration.refresh
      @iteration.project_uri.should == "https://rally1.rallydev.com/slm/webservice/1.19/project/440864397.js"
    end
    it "should assign resources"  do 
      @iteration.refresh
      @iteration.resources.should == "2.0"
    end

    it "should assign revision_history" do 
      @iteration.refresh
      @iteration.revision_uri.should_not be_empty
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
