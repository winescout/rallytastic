class Story
  include Mongoid::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  class << self
    def rally_uri
      "/hierarchicalrequirement.js"
    end
  end

  field :name
  field :rally_uri
  field :created_on, :type => Date
  field :updated_on, :type => Date
  field :description
  field :notes
  field :formatted_id
  field :accepted_on, :type => DateTime
  field :blocked, :type => Boolean
  field :plan_estimate, :type => Integer
  field :predicessor_uris, :type => Array
  field :rank
  field :schedule_state
  field :requested_due_date, :type => Date
  field :theme
  field :revision_history_uri
  field :rally_hash, :type => Hash
  field :is_mmf, :type => Boolean
  field :sized_on,       :type => DateTime
  field :prioritized_on, :type => DateTime
  field :started_on,     :type => DateTime
  field :completed_on,   :type => DateTime

  field :accepted_points
  field :unaccepted_points

  embeds_many :revisions, :inverse_of => :story
  referenced_in :iteration
  referenced_in :project
  referenced_in :parent, :class_name => "Story", :inverse_of => :children
  references_many :children, :class_name => "Story", :inverse_of => :parent

  def epic
    if self.parent
      return parent.epic
    else
      return self
    end
  end

  def refresh_points
    if self.children.empty?
      if self.accepted_on
        points = {:accepted => self.plan_estimate || 0, :unaccepted => 0}
      else
        points = {:unaccepted => self.plan_estimate || 0, :accepted => 0}
      end
    else
      points = self.children.inject({:accepted => 0, :unaccepted => 0}) do |sums,child| 
        child_points = child.refresh_points
        sums[:accepted] +=  child_points[:accepted]
        sums[:unaccepted] += child_points[:unaccepted]
        sums
      end
    end
    self.accepted_points = points[:accepted]
    self.unaccepted_points = points[:unaccepted]
    self.save
    return points
  end
  
  def revision_fields
    [:sized_on, :prioritized_on, :started_on, :completed_on]
  end

  def parse_revisions_for_status_changes
    revision_fields.each do |field|
      timestamp = revision_parser.send(field, revisions)
      self.send("#{field}=", timestamp)
    end
  end
  
  def status_changes
    set_revision_history
    revision_fields.inject({}){|h,field| h[field] = self.send(field.to_s); h}
  end
       
  def revision_parser
    if self.project
      self.project.revision_parser
    end
  end


  def pull_revisions
    revision_history.refresh
    revision_uris = self.revisions.collect{|r| r.rally_uri}
    if revision_history.revisions
      revision_history.revisions.each do |rally_revision|
        unless revision_uris.include?(rally_revision.rally_uri)
          rally_revision.refresh
          self.revisions << rally_revision
        end
      end
    end
    self.parse_revisions_for_status_changes
    self.save
  end

  
  def refresh hash_values=nil
    @rally_hash = hash_values
    from_rally :rally_uri, :_ref
    from_rally :name
    from_rally :notes
    from_rally :is_mmf, :IsMMF
    from_rally :created_on, :CreationDate
    from_rally :description
    from_rally :formatted_id, :FormattedID
    from_rally :updated_on, :LastUpdateDate
    from_rally :accepted_on, :AcceptedDate
    from_rally :blocked
    from_rally :plan_estimate, :PlanEstimate
    from_rally :rank
    from_rally :schedule_state, :ScheduleState
    from_rally :requested_due_date, :RequestedDueDate
    from_rally :theme
    p @rally_hash
    parse_ref :revision_history_uri, @rally_hash["RevisionHistory"]
    self.refresh_points
    self.save
  rescue ArgumentError #getting some bad created_on dates
    puts "Errored on #{self.name}"
    p self
    self.save # save what you can
  end

  def associate hash_values=nil
    @rally_hash = hash_values || RallyAPI.get(self)
    if @rally_hash
      if @rally_hash["Project"]
        project = Project.find_or_create_by(:rally_uri => @rally_hash["Project"]["_ref"])
        self.project = project
      end

      if @rally_hash["Iteration"]
        iteration = Iteration.find_or_create_by(:rally_uri => @rally_hash["Iteration"]["_ref"])
        self.iteration = iteration
      end
      
      if @rally_hash["Parent"]
        story = Story.find_or_create_by(:rally_uri => @rally_hash["Parent"]["_ref"])
        self.parent = story
        story.children << self
        story.save
      end
      
      self.save
    end
  rescue JSON::ParserError => e
    p e
  end


  def revision_history
    RevisionHistory.find_or_create_by(:rally_uri => self.revision_history_uri)
  end
end
