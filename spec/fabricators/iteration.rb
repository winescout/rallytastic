Fabricator(:iteration) do 
  name "Fabricated iteration"
  project {Fabricate(:project)}
end

Fabricator(:iteration_unmocked_parser, :from => :iteration) do 
  name "Fabricated iteration"
  project {Fabricate(:project_unmocked_parser)}
end
