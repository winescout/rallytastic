class Story
  include Mongoid::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  class << self
    def rally_uri
      "/story.js"
    end
  end

  field :name
  field :rally_uri
  field :created_on, :type => Date
  field :description
  field :notes
  field :formatted_id
  field :last_updated_on, :type => Date
  field :accepted_on, :type => Date
  field :blocked, :type => Boolean
  field :plan_estimate, :type => Integer
  field :predicessor_uris, :type => Array
  field :rank
  field :schedule_state
  field :requested_due_date, :type => Date
  field :theme
  field :rally_hash, :type => Hash

  referenced_in :iteration
  referenced_in :parent, :class_name => "Story", :inverse_of => :children
  references_many :children, :class_name => "Story", :inverse_of => :parent

  def refresh hash_values=nil
    @rally_hash = hash_values
    from_rally :rally_uri, :_ref
    from_rally :name
    from_rally :notes
    from_rally :created_on, :_CreatedAt
    from_rally :description
    from_rally :formatted_id, :FormattedID
    from_rally :last_updated_on, :LastUpdateDate
    from_rally :accepted_on, :AcceptedDate
    from_rally :blocked
    from_rally :plan_estimate, :PlanEstimate
    from_rally :rank
    from_rally :schedule_state, :ScheduleState
    from_rally :requested_due_date, :RequestedDueDate
    from_rally :theme

    self.save
  end

  def associate hash_values=nil
    @rally_hash = hash_values if hash_values
    if @rally_hash.has_key?("Iteration")
      iteration = Iteration.find_or_create_by(:rally_uri => @rally_hash["Iteration"]["_ref"])
      self.iteration = iteration
    end
    
    if @rally_hash["Parent"]
      story = Story.find_or_create_by(:rally_uri => @rally_hash["Parent"]["_ref"])
      self.parent = story
    end

    self.save
  end

end
