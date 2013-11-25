# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Fenway::Application.load_tasks

desc "Clear all live game stats from Redis"
task :clear_games => :environment do
Game.pluck(:id).each {|i| GameState::Game.find(i).expire }
end
