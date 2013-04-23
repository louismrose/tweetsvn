require 'twitter'

class Tweeter
  def initialize consumer_key, consumer_secret, oauth_token, oauth_token_secret
    Twitter.configure do |config|
      config.consumer_key = consumer_key
      config.consumer_secret = consumer_secret
      config.oauth_token = oauth_token
      config.oauth_token_secret = oauth_token_secret
    end
  end
  
  def tweet message
    Twitter.update message
  end
end