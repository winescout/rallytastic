require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RevisionHistory do 
  describe "#revisions" do 
    before do 
      @history = Fabricate(:revision_history)
    end
    
    it "should return array" do 
      @history.revisions.class.should == Array
    end
  end
end
