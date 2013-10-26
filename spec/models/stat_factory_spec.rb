require 'spec_helper'

# describe Stat_Factory do
#   describe "#add_player" do
#     let(:team) {FactoryGirl.create(:team)}
#     let(:user) {FactoryGirl.create(:user)}
#     it "adds a user to a team" do 
#       team.add_player(user.id)
#       team.players.count.should eq 1
#       user.teams.count.should eq 1
#       team.players.first.user.id.should eq user.id
#       user.players.first.team.id.should eq team.id
#     end
#   end
# end

describe StatFactory do
  let(:game) {FactoryGirl.build_stubbed(:game)}
  let(:player) {FactoryGirl.build_stubbed(:user)}
  before :each do
    @factory = StatFactory.new(game.id, 0)
  end
    describe "#single" do      
      it "Creates a stat for a player getting a single" do
        stat = @factory.single player.id
        stat.category(:name).should eq "Single"
        stat.game_id.should eq game.id
        stat.user_id.should eq player.id
      end
    describe "#double"
      it "Creates a stat for a player getting a double" do
        stat = @factory.double player.id
        stat.category(:name).should eq "Double"
        stat.game_id.should eq game.id
        stat.user_id.should eq player.id
      end      
    describe "#triple"
      it "Creates a stat for a player getting a triple" do
        stat = @factory.triple player.id
        stat.category(:name).should eq "Triple"
        stat.game_id.should eq game.id
        stat.user_id.should eq player.id
      end      
    end    
end