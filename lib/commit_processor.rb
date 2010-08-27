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
    if commit_contains_log_message?
      publish_commit_message
      publish_bugzilla_link
    end
  end
  
  def publish_commit_message 
    suffix = " (#{author})"
    shortened_log = log[0..(120 - suffix.length - 1)]
    
    @tweeter.tweet shortened_log + suffix
  end
  
  def publish_bugzilla_link
    identifiers = (/(\d+)/).match(log)
    if identifiers
      @tweeter.tweet "https://bugs.eclipse.org/bugs/show_bug.cgi?id=#{identifiers[1]}"
    end
  end
  
private
  def commit_contains_log_message?
    not log.empty?
  end
  
  def log
    first_match(/Log:\s*(.*)\s*/)
  end

  def author
   first_match(/Author: (.*)\s*/).strip
  end

  def first_match regex
    regex.match(@commit)[1]
  end
end