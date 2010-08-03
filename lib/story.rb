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
  references_many :children, :class_name => "Story"

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
end
