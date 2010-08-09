Fabricator(:mocked_revision_parser, :from => :revision_parser) do 
  name "Mocked Revision Parser"
  sized_on(:force => true){ 5.days.ago}
  prioritized_on(:force => true){ 4.days.ago}
  started_on(:force => true){ 3.days.ago}
  completed_on(:force => true){ 2.days.ago}
  junk(:force => true) {"dsaf"}
end

