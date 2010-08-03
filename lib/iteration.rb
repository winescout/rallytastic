class Iteration
  include Mongoid::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  class << self
    def rally_uri
      "/iteration.js"
    end
  end

  field :name
  field :rally_uri
  field :created_on, :type => Date
  field :description
  field :notes
  field :state
  field :start_date, :type => Date
  field :end_date, :type => Date
  field :resources
  field :theme
  
  referenced_in :project
  references_many :stories

  def refresh hash_values=nil
    @rally_hash = hash_values
    from_rally :rally_uri, :_ref
    from_rally :name
    from_rally :theme
    from_rally :state
    from_rally :created_on, :_CreatedAt
    from_rally :start_date, :StartDate
    from_rally :end_date, :EndDate
    from_rally :resources

    self.save
  rescue ArgumentError
    puts "Errored on #{self.name}"
    self.save #save what you can
  end

  def associate hash_values=nil
    @rally_hash = hash_values if hash_values
    if @rally_hash.has_key?("Project")
      project = Project.find_or_create_by(:rally_uri => @rally_hash["Project"]["_ref"])
      project.iterations << self
    end
    self.save
  end
end
