$: << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'rubygems'
require 'update_twitter_from_source_transaction'
require 'xauth_consumer'


class Tweetsvn
  def run
    secrets = load_secrets_from_yaml
    
    source  = GmailCommitSource.new secrets['source']['username'],
                                    secrets['source']['password']
    
    consumer = XauthConsumer.new secrets['twitter']['consumer']['key'],
                                 secrets['twitter']['consumer']['secret']

    tweeter = Tweeter.new consumer,
                          secrets['twitter']['account']['username'],
                          secrets['twitter']['account']['password']
    
    UpdateTwitterFromSourceTransaction.new(source,tweeter).run
  end

private
  def load_secrets_from_yaml
    YAML::load_file('secrets.yml')
  end
end


Tweetsvn.new.run