class RevisionParser
  include Mongoid::Document
  
  field :name
  field :sized_on_regex
  field :prioritized_on_regex
  field :started_on_regex
  field :completed_on_regex

  embedded_in :project, :inverse_of => :revision_parser


  def sized_on(revisions)
    regex = sized_on_regex ? eval(sized_on_regex) : /TASK ESTIMATE TOTAL changed from \[0.0\]/
    first_revision_date_matching regex, revisions
  end
  
  def prioritized_on(revisions)
    regex = prioritized_on_regex ? eval(prioritized_on_regex) : /PROJECT changed from \[[^\]]*\] to \[Madison\]/
    latest_revision_date_matching regex, revisions
  end

  def started_on(revisions)
    regex = started_on_regex ? eval(started_on_regex) : /ITERATION added/ 
    latest_revision_date_matching regex, revisions
  end

  def completed_on(revisions)
    regex = completed_on_regex ? eval(completed_on_regex) : /SCHEDULE STATE changed from \[[^\]]*\] to \[Complete\]/
    latest_revision_date_matching regex, revisions
  end
  
  protected
  def latest_revision_date_matching regexp, revisions
    revision = revisions.desc(:created_on).select{|r| r.description =~ regexp}.first
    Time.parse(revision.created_on) if revision
  end
  
  def first_revision_date_matching regexp, revisions
    revision = revisions.asc(:created_on).select{|r| r.description =~ regexp}.first
    Time.parse(revision.created_on) if revision
  end

end
