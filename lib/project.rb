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

  referenced_in :parent, :class_name => "Project"
  references_many :children, :class_name => "Project"
  references_many :iterations  

  def refresh
    from_rally :name
    from_rally :description
    from_rally :state
    from_rally :notes

    self.save

  end
end
