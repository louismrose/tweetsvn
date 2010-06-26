class XauthConsumer
  def initialize key, secret
    @key    = key
    @secret = secret 
  end
  
  def authenticate username, password
    auth = Twitter::OAuth.new(@key, @secret)
    access_token = access_token_for(username, password)
    auth.authorize_from_access(access_token.token, access_token.secret)
    auth
  end
  
private

  def access_token_for username, password
    consumer = OAuth::Consumer.new @key, @secret, {:site => 'https://api.twitter.com'}
    consumer.get_access_token(nil, {},
      :x_auth_username => username,
      :x_auth_password => password,
      :x_auth_mode => 'client_auth'
    )
  end
end