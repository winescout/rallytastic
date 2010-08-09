require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe RevisionParser do 
  before do 
    @story = Fabricate(:story_with_revisions)
    @parser = @story.iteration.project.create_revision_parser(:name => "live parser")
  end
  
  it "should calculate sized_on" do 
     @parser.sized_on(@story.revisions).to_s.should == 4.days.ago.to_s
  end

  it "should calculate prioritized_on" do 
    @parser.prioritized_on(@story.revisions).to_s.should == 3.days.ago.to_s
  end

  it "should calculate started_on" do 
    @parser.started_on(@story.revisions).to_s.should == 2.days.ago.to_s
  end

  it "should calculate completed_on" do
    @parser.completed_on(@story.revisions).to_s.should == 1.days.ago.to_s
  end
end
