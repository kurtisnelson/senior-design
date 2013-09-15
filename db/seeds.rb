# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Team.create :name => "In State Baseball", :description => "These players are people that went to highschool in Georgia"
Team.create :name => "Out of state baseball", :description => "These players are people that went to school outside of Georgia"
User.create :username => "firewirefahsel", :email => "ryan.fahsel@gmail.com", :team_id => 1 
User.create :username => "kelsonprime", :email => "ruby_guru@gmail.com", :team_id => 2
User.create :username => "bwittenbrook", :email => "bradley.wittebrook@mail.com", :team_id => 1
User.create :username => "cgray9", :email => "colin.gray@gmail.com", :team_id => 2

