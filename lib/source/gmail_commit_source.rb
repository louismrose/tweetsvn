require 'gmail'
require 'source/commit'

class GmailCommitSource
  def initialize username, password
    @gmail = Gmail.new(username, password)
  end
  
  def commits
    unpublished_mail.map { |email| create_commit email }
  end
  
  def mark_as_published commit
    commit.email.label "Tweeted"
    commit.email.archive!
  end

private
  def unpublished_mail
    @gmail.inbox.emails
  end
  
  def create_commit email
    Commit.new email
  end
end