require File.join(File.dirname(__FILE__), 'spec_helper')

describe Project do 
  before do 
    @hash_vals = File.read(File.join(File.dirname(__FILE__), 'fixtures', 'project.txt'))
    RallyAPI.stub(:get).and_return(eval(@hash_vals))
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
      @name = "Down the hatch"
      @project = Project.new(:rally_uri => "http://demouri.com")
    end

    it "should accept a hash of values" do 
      RallyAPI.should_not_receive(:get)
      @project.refresh eval(@hash_vals)
    end

    it "should pull name" do 
      @project.refresh
      @project.name.should == @name
    end
    
    it "should set description" do 
      @project.refresh
      @project.description.should == "A nice description"
    end

    it "should set the notes" do 
      @project.refresh
      @project.notes.should == "some notes"
    end

    it "should set the state" do 
      @project.refresh
      @project.state.should == "Open"
    end
  end
end
