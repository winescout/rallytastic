require File.join(File.dirname(__FILE__), '..', 'rallytastic')
require File.join("~", 'rally_config.rb')

class Scraper < Thor
  desc "projects", "Walk Rally for modified projects, iterations, and stories"
  def projects
    total, page_size, start_index = 1000, 20, 1
    while start = offset(total, page_size, start_index) do
      response = Project.rally_query(:conditions => {:name => "Madison"}, :start => start, :pagesize => page_size)
      response_hash = JSON.parse(response)["QueryResult"]
      p response_hash
      total, page_size, start_index = response_hash["TotalResultCount"], response_hash["PageSize"], response_hash["StartIndex"]
    end
  end

  private
  def offset total, page_size, start_index
    if start_index + page_size >= total
      return nil # we are at th end
    else
      return start_index + page_size
    end
  end

  def updated_since
    DateTime.parse("1-1-2008")
  end
end
