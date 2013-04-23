require 'source/gmail_commit_source'
require_relative 'tweeter'
require_relative 'commit_processor'

class UpdateTwitterFromSourceTransaction
  def initialize commit_source, tweeter
    @source    = commit_source
    @commits   = commit_source.commits
    
    @tweeter   = tweeter
    @processor = CommitProcessor.new @tweeter
  end
  
  def run
    puts "Found #{@commits.length} commits."

    publish_commits

    puts "Published #{@commits.length} commits."
  end
  
private
  def publish_commits
    @commits.each do |commit|
      @processor.publish commit.text
      @source.mark_as_published commit
    end
  end
end