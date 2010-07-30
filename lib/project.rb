class Project
  include MongoMapper::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  key :name, String
  key :rally_id, String
  key :created_on, Time
  key :description, String
  key :notes, String
  key :owner, String
  key :state, String
  key :rally_uri, String
  key :iteration_uris, Array
  key :release_uris, Array
  key :parent_uri, String
  key :children_uris, Array
  key :owner_uri, String
  key :user_uris, Array
  key :rally_hash, Hash
  

  #TODO: extend MM key method to do this mapping
  def refresh
    from_rally :name
    from_rally :rally_id, :ObjectID
    from_rally :description
    from_rally :state
    from_rally :notes
    from_rally :rally_uri, :_ref

    parse_refs :iteration_uris, raw_json["Iterations"]
    parse_refs :user_uris, raw_json["Users"]
    parse_refs :release_uris, raw_json["Releases"]
    parse_refs :children_uris, raw_json["Children"]

    parse_ref :parent_uri, raw_json["Parent"]
    parse_ref :owner_uri, raw_json["Owner"]

    self.save
  end

  def refresh_children
    refresh_list Project, :parent_uri, self.children_uris
  end

  def refresh_iterations
    refresh_list Iteration, :project_uri, self.iteration_uris
  end

  def iterations
    Iteration.all(:project_uri => self.rally_uri)
  end
  
  def children
    Project.all(:parent_uri => self.rally_uri)
  end
end
