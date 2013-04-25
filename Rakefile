desc "Executed by Heroku's cron job"
task :cron do
  require_relative 'tweetsvn.rb'

  Tweetsvn.new.run
end

desc "Set Heroku environment variables from secrets.yml"
task :env do
  require 'yaml'
  require_relative 'lib/util/hash_util.rb'
  
  secrets     = YAML::load_file('config/secrets.yml')
  env_vars    = HashUtil.squash(secrets, '_', 'tweetsvn_').to_a
  environment = env_vars.map {|name,value| "#{name.upcase}='#{value}'" }.join(' ')
  
  sh "heroku config:add #{environment}"
end

unless ENV['RACK_ENV'] == "production"
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
end
