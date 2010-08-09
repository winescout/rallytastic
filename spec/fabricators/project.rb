Fabricator(:project) do
  name "Fabricated project"
  after_create{|project| project.create_revision_parser}
end

Fabricator(:project_mocked_parser, :from => :project) do
  name "Fabricated project, bmocked_parser"
  revision_parser(:force => true){Fabricate.build(:revision_parser)}
end


