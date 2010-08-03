require File.join(File.dirname(__FILE__), '..', 'rallytastic')
require File.join("~", 'rally_config.rb')

class Scraper < Thor
  desc "projects", "Walk Rally for modified projects"
  def projects
    pull_all_from_rally_of_object  Project
  end

  desc "iterations", "Walk Rally for modified iterations"
  def iterations
    pull_all_from_rally_of_object  Iteration
  end

  private
  def pull_all_from_rally_of_object  klass
    total, page_size, start_index = 10000, 100, 1
    while start = offset(total, page_size, start_index) do
      response = klass.rally_query(:fetch => true, :start => start, :pagesize => page_size)
      response_hash = JSON.parse(response)["QueryResult"]
      process_results klass, response_hash["Results"]
      total, page_size, start_index = response_hash["TotalResultCount"], response_hash["PageSize"], response_hash["StartIndex"]
    end
  end
  
  def process_results klass, results
    results.each do |result|
      local = klass.find_or_create_by(:rally_uri => result["_ref"])
      local.refresh(result)
      local.associate(result)
    end
  end

  def offset total, page_size, start_index
    if start_index >= total
      return nil # we are at th end
    else
      return start_index + page_size
    end
  end

  def updated_since
    DateTime.parse("1-1-2008")
  end
end
