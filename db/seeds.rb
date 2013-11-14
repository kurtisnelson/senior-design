# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.id)
#Team.create :name => "In State Baseball", :description => "These players are people that went to highschool in Georgia"
#Team.create :name => "Out of state baseball", :description => "These players are people that went to school outside of Georgia"
team1 = FactoryGirl.create(:team)
team2 = FactoryGirl.create(:team)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team1.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
FactoryGirl.create(:player, :team_id => team2.id)
