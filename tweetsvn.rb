$: << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'rubygems'
require 'update_twitter_from_source_transaction'


class Tweetsvn
  def run
    secrets = load_secrets_from_yaml
    
    source  = GmailCommitSource.new secrets['source']['username'],  secrets['source']['password'] 
    tweeter = Tweeter.new           secrets['twitter']['username'], secrets['twitter']['password']
    
    UpdateTwitterFromSourceTransaction.new(source,tweeter).run
  end

private
  def load_secrets_from_yaml
    YAML::load_file('secrets.yml')
  end
end


Tweetsvn.new.run