require File.join(File.dirname(__FILE__), 'spec_helper')

describe Project do 
  before do 
    hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'project.txt'))
    RallyAPI.stub(:get).and_return(eval(hash_vals))
  end

  describe "iterations" do 
    before do 
      Project.collection.remove
      Iteration.collection.remove
      @rally_id = "440861167"
      @project = Project.new(:rally_id => @rally_id)
      @project.refresh
    end

    it "should refresh iterations" do 
      hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'iteration.txt'))
      RallyAPI.stub(:get).and_return(eval(hash_vals))
      @project.refresh_iterations
      @project.iterations.count.should > 0
    end
  end

  describe "child projects" do 
    before do 
      Project.collection.remove
      @rally_id = "440861167"
      @project = Project.new(:rally_id => @rally_id)
      @project.refresh
    end

    it "should return array of projects" do 
      @child = Project.create(:rally_id => 12345, :parent_uri => @project.rally_uri)
      @project.children.should include(@child)
    end

   it "should lookup all children" do 
     hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'child_project.txt'))
     RallyAPI.stub(:get).and_return(eval(hash_vals))
     @project.refresh_children
     @project.children.count.should == @project.children_uris.count
   end

   it "should remove stale iterations" do
     hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'child_project.txt'))
     RallyAPI.stub(:get).and_return(eval(hash_vals))
     original_count = @project.children_uris.count
     @project.refresh_children
     @project.children_uris.pop
     @project.refresh_children
     @project.children.count.should == original_count - 1
   end
end

 describe "looking up attrs from Rally for invalid project" do 
   before do 
     Project.collection.remove
     @project = Project.new
   end

   it "should raise error" do 
     lambda{@project.refresh}.should raise_error
   end
 end

  describe "looking up attrs from Rally for valid project" do 
    before do 
      Project.collection.remove
      @rally_id = "440861167"
      @name = "Down the hatch"
      @project = Project.new(:rally_id => @rally_id)
    end

    it "should pull rally_uri" do 
      @project.refresh
      @project.rally_uri.should =~ /project/
    end

    it "should pull name" do 
      @project.refresh
      @project.name.should == @name
    end

    it "should pull iteration uris"do 
      @project.refresh
      @project.iteration_uris.count.should_not be_nil
    end
    
    it "should pull children uris" do 
      @project.refresh
      @project.children_uris.count.should_not be_nil
    end

    it "should set description" do 
      @project.refresh
      @project.description.should == "A nice description"
    end

    it "should set the notes" do 
      @project.refresh
      @project.notes.should == "some notes"
    end

    it "should set the owner_uri" do 
      @project.refresh
      @project.owner_uri.should == "https://rally1.rallydev.com/slm/webservice/1.19/user/411781343443.js"
    end

    it "should set the parent uri" do 
      @project.refresh
      @project.parent_uri.should == "https://rally1.rallydev.com/slm/webservice/1.19/project/411780344343.js"
    end

    it "should set the release uris" do 
      @project.refresh
      @project.release_uris.should_not be_empty
    end

    it "should set the state" do 
      @project.refresh
      @project.state.should == "Open"
    end

    it "shold set the users uris" do 
      @project.refresh
      @project.user_uris.should_not be_empty
    end
   
    it "should provide access to the raw json from Rally" do 
      @project.raw_json.should_not be_nil
    end

    it "should not refresh unless requested" do 
      RallyAPI.should_receive(:get).exactly(1).times.and_return({:name => "name"})
      2.times do 
        @project.raw_json
      end
    end

    it "should refresh if requested" do 
      RallyAPI.should_receive(:get).exactly(2).times.and_return({:name => "name"})
      2.times do 
        @project.raw_json(:refresh => true)
      end
    end
  end
end
