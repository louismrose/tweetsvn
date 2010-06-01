require 'gmail'
require 'source/commit'

class GmailCommitSource
  def initialize username, password
    @gmail = Gmail.new(username, password)
  end
  
  def commits
    unread_mail.map { |email| create_commit_and_keep_unread email }
  end
  
  def mark_as_published commit
    commit.email.mark :read
  end

private
  def unread_mail
    @gmail.inbox.emails :unread
  end
  
  def create_commit_and_keep_unread email
    commit = Commit.new email # causes email to be marked as read
    email.mark :unread
    commit
  end
end