require 'gmail'
require_relative 'commit'

class GmailCommitSource
  def initialize username, password
    @gmail = Gmail.new(username, password)
  end
  
  def commits
    queued_mail.map { |email| create_commit email }
  end
  
  def mark_as_published commit
    # creates a copy of the email in the Tweeted mailbox
    commit.email.label "Tweeted" 
    
    # delete the original email from the Queued mailbox
    commit.email.delete!
  end

private
  def queued_mail
    @gmail.mailbox("Queued").emails
  end
  
  def create_commit email
    Commit.new email
  end
end