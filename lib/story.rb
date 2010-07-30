class Story
  include MongoMapper::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  key :name, String
  key :rally_uri, String
  key :rally_id, String
  key :created_on, Time
  key :description, String
  key :notes, String
  key :owner_uri, String
  key :discussion_uris, Array
  key :formatted_id, String
  key :last_updated_on, Date
  key :accepted_on, Date
  key :blocked, Boolean
  key :blocker_uri, String
  key :children_uris, Array
  key :defect_uris, Array
  key :iteration_uri, String
  key :parent_uri, String
  key :plan_estimate, Integer
  key :predicessor_uris, Array
  key :rank, String
  key :release_uri, String
  key :schedule_state, String
  key :test_case_uris, Array
  key :requested_due_date, Date
  key :requestor_uri, String
  key :theme, String
  key :rally_hash, Hash


  def refresh
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

    parse_ref :owner_uri, raw_json["Owner"]
    parse_ref :blocker_uri, raw_json["Blocker"]
    parse_ref :iteration_uri, raw_json["Iteration"]
    parse_ref :parent_uri, raw_json["Parent"]
    parse_ref :release_uri, raw_json["Release"]
    parse_ref :requestor_uri, raw_json["Requestor"]

    parse_refs :children_uris, raw_json["Children"]
    parse_refs :defect_uris, raw_json["Defects"]
    parse_refs :predicessor_uris, raw_json["Predicessors"]
    parse_refs :test_case_uris, raw_json["TestCases"]
    parse_refs :discussions, raw_json["Discussion"]

    self.save
  end
end
