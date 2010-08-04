require File.join(File.dirname(__FILE__), '..', 'rallytastic')

class Docs < Thor
  desc "update_readme", "Updates README.doc with thor task descriptions for project"
  def update_readme
    tasks = Scraper.printable_tasks
    file_path = File.join(File.dirname(__FILE__), '..', '..', 'README.rdoc')

    #indexes of thor section
    f = File.open(file_path)
    lines = f.readlines
    start = lines.index("=== Thor Tasks\n")
    finish = lines.index("<End of Thor Tasks>\n")
    f.close
    
    #write new README
    f = File.open(file_path, "w+")
    lines[0..start].each{|l| f << l}
    tasks.each{|l| write_thor_task f, l}
    lines[finish..-1].each{|l| f << l}
    f.close

  end

  private
  def write_thor_task file, task
    command_parts = task[0].split(" ")
    file << "==== #{command_parts[1..-1].join(" ")}\n"
    file << "#{task[1]}\n"
  end
end
