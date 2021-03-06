Fabricator(:revision_history) do 
  revision_uris ["http://revision_1.uri", "http://revision_2.uri"]
  refresh true
end

Fabricator(:revision_history_mocked_revisions, :from => :revision_history) do 
  revision_uris ["http://revision_1.uri", "http://revision_2.uri"]
  revisions(:force => true){[Fabricate.build(:revision), Fabricate.build(:revision)]}
  refresh true
end
