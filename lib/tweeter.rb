require 'twitter'

class Tweeter
  def initialize consumer, username, password
    @client = Twitter::Base.new consumer.authenticate(username, password)
  end
  
  def tweet message
    @client.update message
  end
end