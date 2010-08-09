Fabricator(:story) do 
  name "Factory Story"
  iteration {Fabricate(:iteration)}
  revision_history(:force => true){Fabricate.build(:revision_history)}
end

Fabricator(:story_with_revisions, :from => :story) do 
  name "Factory Story with revisions"
  revisions {[Fabricate.build(:revision, 
                              :created_on => 4.days.ago, 
                              :description => "TASK ESTIMATE TOTAL changed from [0.0] to [2.0]"),
              Fabricate.build(:revision, 
                              :created_on => 3.days.ago, 
                              :description => "PROJECT changed from [Photos.com] to [Madison]"),
              Fabricate.build(:revision, 
                              :created_on => 2.days.ago, 
                              :description => "ITERATION added"),
              Fabricate.build(:revision, 
                              :created_on => 1.days.ago, 
                              :description => "SCHEDULE STATE changed from [InProgress] to [Complete]")]}
end

#Fabricator(:story_unmocked_parser, :from => :story) do
#  name "Factory Story, Unmocked Parser"
#  iteration {Fabricate(:iteration_unmocked_parser)}
#  revision_history(:force => true){Fabricate.build(:revision_history)}
#end
