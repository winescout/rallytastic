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

  #TODO: extend MM key method to do this mapping
  def refresh
    from_rally :name
    from_rally :description
    from_rally :state
    from_rally :notes

    self.save

  end
end
