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

  referenced_in :parent, :class_name => "Project", :inverse_of => :children
  references_many :children, :class_name => "Project", :inverse_of => :parent
  references_many :iterations  
  references_many :stories
  embeds_one :revision_parser

  def ancestors
    if parent
      a = parent.ancestors << self
      return a
    else
      return [self]
    end
  end

  
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
    @rally_hash = hash_values || RallyAPI.get(self)
    #TODO: associate with user when users are supported
    if @rally_hash["Parent"]
      parent = Project.find_or_create_by(:rally_uri => @rally_hash["Parent"]["_ref"])
      parent.children << self
      parent.save
      self.parent = parent
    end
    self.save
  end
end
