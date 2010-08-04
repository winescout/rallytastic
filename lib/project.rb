class Project
  include Mongoid::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  class << self
    def rally_uri
      "/project.js"
    end
  end

  field :name
  field :rally_uri
  field :created_on
  field :description
  field :notes
  field :state

  field :revision_parser

  referenced_in :parent, :class_name => "Project"
  references_many :children, :class_name => "Project"
  references_many :iterations  

  def refresh hash_values=nil
    @rally_hash = hash_values if hash_values
    from_rally :name
    from_rally :description
    from_rally :state
    from_rally :notes

    self.save

  end
  
  #must be called after refresh, or with has_values passed in
  def associate hash_values=nil
    @rally_hash = hash_values if hash_values
    #TODO: associate with user when users are supported
    if @rally_hash["Parent"]
      parent = Project.find_or_create_by(:rally_uri => @rally_hash["Parent"]["_ref"])
      self.parent = parent
    end
    self.save
  end
end
