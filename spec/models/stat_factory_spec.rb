require 'spec_helper'

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
    describe "#strike_out"
      it "Creates a stat for a player getting a triple" do
        stat = @factory.strike_out player.id
        stat.category(:name).should eq "Strike Out"
        stat.game_id.should eq game.id
        stat.user_id.should eq player.id
      end        
    describe "#homerun"
      it "Creates a stat for a player getting a homerun" do
        stat = @factory.homerun player.id
        stat.category(:name).should eq "Homerun"
        stat.game_id.should eq game.id
        stat.user_id.should eq player.id
      end        
    end
    describe "#steal"
      it "Creates a stat for a player getting a steal" do
        stat = @factory.steal player.id
        stat.category(:name).should eq "Steal"
        stat.game_id.should eq game.id
        stat.user_id.should eq player.id
    end  
    describe "#rbi"
      it "Creates a stat for a player getting a rbi" do
        stat = @factory.rbi player.id
        stat.category(:name).should eq "RBI"
        stat.game_id.should eq game.id
        stat.user_id.should eq player.id
    end      
end