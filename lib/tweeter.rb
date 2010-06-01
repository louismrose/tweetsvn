require 'twitter'

class Tweeter
  def initialize username, password
    oauth = Twitter::OAuth.new('n8u91BEifjiy6KroA8rF3g', 'pj5bKf8ZcdCSStaXo1n6xAuqfUpgNR3iJ9Ylya951qE')
    oauth.authorize_from_access(username, password)
    
    @client = Twitter::Base.new oauth
  end
  
  def tweet message
    @client.update message
  end
end