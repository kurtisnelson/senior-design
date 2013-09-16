def app_name_from_environment(env)
  case env
  when "production"
    "fenway"
  end
end

desc 'Deploy Safely to Heroku'
task :deploy do
  env = ENV['ENV']
  env ||= 'production'
  abort "Please specify ENV=production or ENV=staging" unless env

  app_name = app_name_from_environment(env)
  sh "git push heroku master"
  Bundler.clean_system "heroku pgbackups:capture --expire --app #{app_name}"
  Bundler.clean_system "heroku run rake db:migrate --app #{app_name}"
  Bundler.clean_system "heroku restart --app #{app_name}"
  sh "curl -o /dev/null http://#{app_name}.herokuapp.com"
end
