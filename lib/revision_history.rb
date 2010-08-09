class RevisionHistory
  include Mongoid::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods
  
  field :revision_uris, :type => Array

  class << self
    def rally_uri
      "/revisionhistory.js"
    end
  end

  def refresh
    parse_refs :revision_uris, raw_json["Revisions"]
    self.save
  end
end
