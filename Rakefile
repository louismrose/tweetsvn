desc "Executed by Heroku's cron job"
task :cron do
  require 'tweetsvn.rb'

  Tweetsvn.new.run
end

desc "Set Heroku environment variables from secrets.yml"
task :env do
  require 'yaml'
  require 'lib/util/hash_util.rb'
  
  secrets     = YAML::load_file('secrets.yml')
  env_vars    = HashUtil.squash(secrets).to_a
  environment = env_vars.map {|name,value| name.upcase + "=" + value }.join(' ')
  
  sh "heroku config:add #{environment}"
end