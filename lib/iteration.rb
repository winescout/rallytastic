class Iteration
  include MongoMapper::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  key :name, String
  key :rally_id, String
  key :rally_uri, String
  key :created_on, Date
  key :description, String
  key :notes, String
  key :state, String
  key :start_date, Date
  key :end_date, Date
  key :resources, String
  key :theme, String
  key :project_uri, String  
  key :revision_uri, String
  key :rally_hash, Hash


  def refresh
    self.rally_uri ||= raw_json["_ref"]
    self.name = raw_json["Name"]
    self.theme = raw_json["Theme"]
    self.state = raw_json["State"]
    self.created_on = raw_json["_CreatedAt"]
    self.start_date = raw_json["StartDate"]
    self.end_date = raw_json["EndDate"]
    self.resources = raw_json["Resources"].to_i
    parse_ref :project_uri, raw_json["Project"]
    parse_ref :revision_uri, raw_json["RevisionHistory"]
    self.save
  end

end
