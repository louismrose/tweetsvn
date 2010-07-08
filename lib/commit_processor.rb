class CommitProcessor
  def initialize tweeter
    @tweeter = tweeter
  end
  
  def publish commit
    SingleCommitProcessor.new(commit, @tweeter).publish
  end
end

class SingleCommitProcessor
  def initialize commit, tweeter
    @commit  = commit
    @tweeter = tweeter
  end

  def publish
    publish_commit_message
    publish_bugzilla_link
  end
  
  def publish_commit_message 
    log_length = 120 - author.length - 3
    
    @tweeter.tweet "#{log log_length} (#{author})"
  end
  
  def publish_bugzilla_link
    identifiers = (/#(\d+)/).match(@commit)
    if identifiers
      @tweeter.tweet "https://bugs.eclipse.org/bugs/show_bug.cgi?id=#{identifiers[1]}"
    end
  end
  
private
  def log maximum_length
    first_match(/Log:\s*(.*)\s*/)[0..maximum_length-1]
  end

  def author
   first_match(/Author: (.*)\s*/).strip
  end

  def first_match regex
    regex.match(@commit)[1]
  end
end