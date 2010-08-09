# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rallytastic}
  s.version = "1.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Matt Clark"]
  s.date = %q{2010-08-08}
  s.description = %q{longer description of your gem}
  s.email = %q{winescout@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "Gemfile",
     "Gemfile.lock",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/iteration.rb",
     "lib/project.rb",
     "lib/rally/parsing_helpers.rb",
     "lib/rally/rally_api.rb",
     "lib/rallytastic.rb",
     "lib/revision.rb",
     "lib/revision_history.rb",
     "lib/revision_parser.rb",
     "lib/story.rb",
     "lib/tasks/docs.thor",
     "lib/tasks/scraper.thor",
     "rallytastic.gemspec",
     "spec/fabricators/iteration.rb",
     "spec/fabricators/project.rb",
     "spec/fabricators/revision.rb",
     "spec/fabricators/revision_history.rb",
     "spec/fabricators/revision_parser.rb",
     "spec/fabricators/story.rb",
     "spec/fixtures/child_project.txt",
     "spec/fixtures/iteration.txt",
     "spec/fixtures/project.txt",
     "spec/fixtures/story.txt",
     "spec/fixtures/story_query.txt",
     "spec/iteration_spec.rb",
     "spec/project_spec.rb",
     "spec/rally/rally_api_spec.rb",
     "spec/revision_history_spec.rb",
     "spec/revision_parser_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb",
     "spec/story_spec.rb"
  ]
  s.homepage = %q{http://github.com/winescout/rallytastic}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Its a Rally story teleporter}
  s.test_files = [
    "spec/fabricators/iteration.rb",
     "spec/fabricators/project.rb",
     "spec/fabricators/revision.rb",
     "spec/fabricators/revision_history.rb",
     "spec/fabricators/revision_parser.rb",
     "spec/fabricators/story.rb",
     "spec/iteration_spec.rb",
     "spec/project_spec.rb",
     "spec/rally/rally_api_spec.rb",
     "spec/revision_history_spec.rb",
     "spec/revision_parser_spec.rb",
     "spec/spec_helper.rb",
     "spec/story_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<mongoid>, [">= 0"])
      s.add_runtime_dependency(%q<bson_ext>, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<thor>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 1.2.9"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<mongoid>, [">= 0"])
      s.add_dependency(%q<bson_ext>, [">= 0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<thor>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.2.9"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<mongoid>, [">= 0"])
    s.add_dependency(%q<bson_ext>, [">= 0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<thor>, [">= 0"])
  end
end

