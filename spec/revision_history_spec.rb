require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RevisionHistory do 
  describe "#revisions" do 
    before do 
      @history = Fabricate(:revision_history)
    end
    
    it "should return array" do 
      @history.revisions.class.should == Array
    end
    
    it "should return array even if revision_history is empty" do 
      @history.stub(:revision_uris).and_return(nil)
      @history.revisions.class.should == Array
    end
  end
end
