class Revision
  include Mongoid::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  field :description
  field :revision_number
  field :created_on

  embedded_in :story, :inverse_of => :revisions

  def refresh hash_values=nil
    @rally_hash = hash_values if hash_values
    from_rally :description
    from_rally :revision_number
    from_rally :created_on, :CreationDate
  end
end
