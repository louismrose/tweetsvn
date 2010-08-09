require 'tweetsvn'

while true
  sleep 60 * 15
  Tweetsvn.new.run
end