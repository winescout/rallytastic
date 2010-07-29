class Story
  include MongoMapper::Document
  include Rally::ParsingHelpers
  extend Rally::ParsingHelperClassMethods

  key :name, String
  key :rally_id, String
  key :created_on, Time
  key :description, String
  key :notes, String
  key :owner, String
end
