require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Story do 
  describe "#associate" do 
    before do 
      @hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'story.txt'))
      @story = Story.new(:rally_uri => "http://testuri.com")
    end
    
    it "should associate parent" do 
      @story.associate(eval(@hash_vals)["HierarchicalRequirement"])
      @story.parent.should_not be_nil
    end

    it "should associate iteration" do 
      @story.associate(eval(@hash_vals)["HierarchicalRequirement"])
      @story.iteration.should_not be_nil
    end

  end

  describe "#refresh" do 
    before do 
      hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'story.txt'))
      RallyAPI.stub(:get).and_return(eval(hash_vals))
      @story = Story.new(:rally_uri => "http://testuri")
      @story.refresh
    end

    it "should set name" do 
      @story.name.should == "Run the marathon"
    end

    it "should set the rally_uri" do 
      @story.rally_uri.should == "https://rally1.rallydev.com/slm/webservice/1.19/hierarchicalrequirement/413668210.js"
    end

    it "should set the created_on" do 
      @story.created_on.should ==DateTime.parse("2009-06-11UTC")
    end
 
    it "should set the description" do 
      @story.description.should == "You've trained for it, now do it.  Done when, you run 26.2 miles."
    end

    it "should set the formatted_id" do 
      @story.formatted_id.should == "US26"
    end

    it "should set updated_on" do 
      @story.updated_on.should == Date.parse("2009-09-10T18:57:55.000Z")
    end

    it "should set accepted_date" do 
      @story.accepted_on.should == DateTime.parse("2009-09-10T18:57:55.000Z")
    end

    it "should set blocked" do
      @story.blocked.should === false
    end

    it "should set plan_estimate" do 
      @story.plan_estimate.should == 3
    end

    it "should set rank" do 
      @story.rank.should == "86292398717311774535928819836502410.432"
    end 
    
    it "should set schedule_state" do 
      @story.schedule_state.should == "Accepted"
    end

    it "should set requested_due_date" do 
      @story.requested_due_date.should == Date.parse("2009-06-11T16:12:46.000Z")
    end

    it "should set theme" do 
      @story.theme.should == "this is the theme"
    end
  end

  describe "#revision_parser" do 
    before do 
      @story = Fabricate(:story)
    end

    it "should return new parser" do 
      @story.revision_parser.class.should == RevisionParser
    end
  end

  describe "#pull_revisions" do 
    before do
      @story = Fabricate(:story)
    end

    it "should pull revisions from revision history" do 
      @story.revisions.count.should == 0
      @story.pull_revisions
      @story.revisions.count.should == 2
    end
  end
end
