require 'rubygems'
require 'bundler'
Bundler.setup

require 'yaml'
require_relative 'lib/update_twitter_from_source_transaction'

class Tweetsvn
  def run
    load_secrets
    
    source  = GmailCommitSource.new @secrets['source']['username'],
                                    @secrets['source']['password']

    tweeter = Tweeter.new @secrets['twitter']['consumer']['key'],
                          @secrets['twitter']['consumer']['secret'],
                          @secrets['twitter']['access']['token'],
                          @secrets['twitter']['access']['secret']
    
    UpdateTwitterFromSourceTransaction.new(source,tweeter).run
  end

private
  def load_secrets
    if File.exists?('config/secrets.yml')
      @secrets = YAML::load_file('config/secrets.yml')
    else
      @secrets = {
                   'source' => {
                     'username' => ENV['TWEETSVN_SOURCE_USERNAME'],
                     'password' => ENV['TWEETSVN_SOURCE_PASSWORD']
                   },
                   'twitter' => {
                     'consumer' => {
                       'key'    => ENV['TWEETSVN_TWITTER_CONSUMER_KEY'],
                       'secret' => ENV['TWEETSVN_TWITTER_CONSUMER_SECRET']
                     },
                     'access' => {
                       'token' => ENV['TWEETSVN_TWITTER_ACCESS_TOKEN'],
                       'secret' => ENV['TWEETSVN_TWITTER_ACCESS_SECRET']
                     }
                   }
                 }
    end
  end
end