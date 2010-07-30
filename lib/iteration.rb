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
    from_rally :rally_uri, :_ref
    from_rally :name
    from_rally :theme
    from_rally :state
    from_rally :created_on, :_CreatedAt
    from_rally :start_date, :StartDate
    from_rally :end_date, :EndDate
    from_rally :resources

    parse_ref :project_uri, raw_json["Project"]
    parse_ref :revision_uri, raw_json["RevisionHistory"]

    self.save
  end

  def stories
    Story.all(:project_uri => self.rally_uri)
  end

  #TODO: there is no pagination understanding here
  def refresh_stories
    existing = Story.all(:iteration_uri => self.rally_uri)
    query_result = RallyAPI.query(:heirarchical_requirement, :query => "(Iteration = #{self.rally_id})", :limit => 100)
    
    stories = query_result["QueryResult"]["Results"]

    uris = []
    stories.each do |story| 
      Story.from_uri(story["_ref"]); uris << story["_ref"] 
    end
    
    #remove stale stories
    stale = existing.reject{|obj| uris.include? obj.rally_uri}
    
  end
end
