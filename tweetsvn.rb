$: << File.expand_path(File.dirname(__FILE__) + '/lib')

require 'rubygems'
require 'bundler'
Bundler.setup

require 'update_twitter_from_source_transaction'
require 'xauth_consumer'


class Tweetsvn
  def run
    load_secrets
    
    source  = GmailCommitSource.new @secrets['source']['username'],
                                    @secrets['source']['password']
    
    consumer = XauthConsumer.new @secrets['twitter']['consumer']['key'],
                                 @secrets['twitter']['consumer']['secret']

    tweeter = Tweeter.new consumer,
                          @secrets['twitter']['account']['username'],
                          @secrets['twitter']['account']['password']
    
    UpdateTwitterFromSourceTransaction.new(source,tweeter).run
  end

private
  def load_secrets
    if File.exists?('config/secrets.yml')
      @secrets = YAML::load_file('config/secrets.yml')
    else
      @secrets['source']['username'] = ENV['TWEETSVN_SOURCE_USERNAME']
      @secrets['source']['password'] = ENV['TWEETSVN_SOURCE_PASSWORD']
      
      @secrets['twitter']['consumer']['key']    = ENV['TWEETSVN_TWITTER_CONSUMER_KEY']
      @secrets['twitter']['consumer']['secret'] = ENV['TWEETSVN_TWITTER_CONSUMER_SECRET']
      @secrets['twitter']['account']['username'] = ENV['TWEETSVN_TWITTER_CONSUMER_KEY']
      @secrets['twitter']['account']['password'] = ENV['TWEETSVN_TWITTER_CONSUMER_KEY']
    end
  end
end