class RevisionHistory
  include Mongoid::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods
  
  field :revisions, :type => Array

  class << self
    def rally_uri
      "/revisionhistory.js"
    end
  end

  def refresh
    parse_refs :revisions, raw_json["Revisions"]
    self.save
  end

end
