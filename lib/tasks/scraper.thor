require File.join(File.dirname(__FILE__), '..', 'rallytastic')
require File.join("~", 'rally_config.rb')

class Scraper < Thor
  desc "refresh", "Pulls down Rally stories since the last run, and creates Iterations and Projects as needed.  This is the task you want to put in your job scheduler."
  def refresh
    stories
    update_non_stories
  end

  desc "stories", "Walk Rally stories updated since last run"
  def stories
    most_recent = Story.desc(:updated_on).limit(1).first
    if most_recent
      pull_all_from_rally_of_object Story, :conditions => {:LastUpdateDate.gt => most_recent.updated_on.to_s}
    else
      pull_all_from_rally_of_object Story
    end

  end
  
  desc "update_non_stories", "The scrape:stroies task creates shell iterations and projects for any that it doesn't know about yet.  This task looks for those, and pull their information down from Rally"
  def update_non_stories
    Iteration.all(:conditions => {:name => nil, :rally_uri.ne => nil}).each{|i| i.refresh; i.associate}
    Project.all(:conditions => {:name => nil, :rally_uri.ne => nil}).each{|s| s.refresh; i.associate}
  end

  desc "revisions iteration_name", "Get the revisions for stories hanging off an iteration"
  def revisions iteration_name
    iteration = Iteration.find(:conditions => {:name => iteration_name}).first
    iteration.stories.each{|story| revisions_for_story(story)}
  end
  
  desc "projects", "Bootstrapping method that is primarily useful when you are setting up Rallytastic for the first time. It will walk Rally and pull down all projects.  Technically, you don't need to run this because using the scrape:stories; scrape:update_non_stories; will fill this information in for you.  It may be a bit quicker though to run this first if you have a lot of projects because it does batch queries"
  def projects
    pull_all_from_rally_of_object  Project
  end

  desc "iterations", "Bootstrapping method that is primarily useful when you are setting up Rallytastic for the first time. It will walk Rally and pull down all Iterations.  Technically, you don't need to run this because using the scrape:stories; scrape:update_non_stories; will fill this information in for you.  It may be a bit quicker though to run this first if you have a lot of iterations because it does batch queries"
  def iterations
    pull_all_from_rally_of_object  Iteration
  end

  private
  def revisions_for_story(story)
    story_in_rally = RallyAPI.get(story)
    revision_list = RevisionHistory.new(:rally_uri => story_in_rally["RevisionHistory"]["_ref"])
    revision_list.refresh
    revision_uris = story.revisions.collect{|r| r.rally_uri}
    if revision_list.revisions
      revision_list.revisions.each do |uri|
        unless revision_uris.include?(uri)
          r = Revision.new(:rally_uri => uri)
          r.refresh
          story.revisions << r
        end
      end
    end
    story.set_revision_history
    story.save
  end

  def pull_all_from_rally_of_object  klass, options={}
    total, page_size, start_index = nil, 100, 1
    while start_index = offset(total, page_size, start_index) do
      query = {:fetch => true, :start => start_index, :pagesize => page_size}.merge(options)
      response = klass.rally_query(query)
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
    if total.nil? #first pass
      return start_index
    elsif start_index >= total
      return nil # we are at th end
    else
      return start_index + page_size
    end
  end

  def updated_since
    DateTime.parse("1-1-2008")
  end
end
