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
  
  def revisions
    self.revision_uris ||= []
    revision_uris.collect do |uri|
      Revision.new(:rally_uri => uri)
    end
  end
end
