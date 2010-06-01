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
    log_length = 120 - author.length - 3

    @tweeter.tweet "#{log log_length} (#{author})"
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