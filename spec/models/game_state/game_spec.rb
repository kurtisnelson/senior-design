require 'spec_helper'

describe GameState::Game do
  let(:state) { GameState::Game.new(FactoryGirl.create(:game).id) }

  describe "#single" do
    it "moves the player at bat to first base" do
      (0..3).each {|id| state.lineups.away.add id}
      state.single!
      state.at_bat.should eq 1
      state.on_base(1).should eq 0
    end
    it "resets balls and strikes" do
      state.strike!
      state.ball!
      state.lineups.away.add 0
      state.single!
      state.balls.should eq 0
      state.strikes.should eq 0
    end
    it "creates a stat for a single for the player at bat" do
      state.lineups.away.add 42
      stat = state.single!
      stat.user_id.should eq 42
      stat.category(:name).should eq "Single"
      stat.game_id.should eq state.id
    end
  end

  describe "#double" do
    it "moves the player at bat to second base" do
      state.lineups.away.add 1
      state.lineups.away.add 2
      state.at_bat.should eq 1
      state.double!
      state.at_bat.should eq 2
      state.on_base(1).should eq 0
      state.on_base(2).should eq 1
    end
    it "resets balls and strikes" do
      state.strike!
      state.ball!
      state.double!
      state.balls.should eq 0
      state.strikes.should eq 0
    end
    it "creates a stat for a double for the player at bat" do
      state.lineups.away.add 42
      stat = state.double!
      stat.user_id.should eq 42
      stat.category(:name).should eq "Double"
      stat.game_id.should eq state.id
    end

  end

  describe "#triple" do
    it "moves the player at bat to third base" do
      state.lineups.away.add 5
      state.triple!
      state.on_base(1).should eq 0
      state.on_base(2).should eq 0
      state.on_base(3).should eq 5
    end
    it "resets balls and strikes" do
      state.strike!
      state.ball!
      state.triple!
      state.balls.should eq 0
      state.strikes.should eq 0
    end
    it "creates a stat for a triple for the player at bat" do
      state.lineups.away.add 42
      stat = state.triple!
      stat.user_id.should eq 42
      stat.category(:name).should eq "Triple"
      stat.game_id.should eq state.id
    end    
  end

  describe "#homerun" do
    it "the people on first,second,third and batting all clear bases" do
      state.lineups.away.add 1
      state.lineups.away.add 2
      state.lineups.away.add 3
      state.lineups.away.add 4
      state.homerun!
      state.on_base(1).should eq 0
      state.on_base(2).should eq 0
      state.on_base(3).should eq 0
    end
    it "creates a stat for a homerun for the player at bat" do
      state.lineups.away.add 42
      stat = state.homerun!
      stat.user_id.should eq 42
      stat.category(:name).should eq "Homerun"
      stat.game_id.should eq state.id
    end
  end

  describe "#run" do
    it "in crements the away score by 1" do 
      state.away_score.should eq 0
      state.run! state.inning.top?
      state.away_score.should eq 1
    end
    it "increments the home score by 1" do
      state.home_score.should eq 0 
      state.run! state.inning.bottom?
      state.home_score.should eq 1
    end
    it "gives the last person to bat an rbi" do
      state.lineups.away.add 1
      state.lineups.away.add 2
      state.single!
      state.double!
      stat = state.run! state.inning.top?
      stat.user_id.should eq 2
      stat.category(:name).should eq "RBI"
      stat.game_id.should eq state.id
    end
  end
  describe "#out!" do
    it "increments the out count on a fresh game" do
      state.out
      state.outs.should eq 1
    end
    it "calls next_inning after 3 outs" do
      state.should_receive(:next_inning!).once
      state.out
      state.out
      state.out
    end
    it "records a strike out stat when out is called on current batter" do
      state.lineups.away.add 32
      stat = state.out! 32
      stat.user_id.should eq 32
      stat.category(:name).should eq "Strike Out"
      stat.game_id.should eq state.id
    end
  end

  describe "#next_inning!" do
    it "resets outs" do
      state.outs = 100
      state.next_inning!
      state.outs.should eq 0
    end
  end

  describe "#strike!" do
    it "increments the strike count on a fresh game" do
      state.strike!
      state.strikes.should eq 1
    end

    it "calls out after 3 strikes" do
      state.should_receive(:out).once
      state.strike!
      state.strike!
      state.strike!
    end
  end

  describe "#ball" do
    it "calls walk after 4 balls" do
      state.should_receive(:walk!).once
      state.ball!
      state.ball!
      state.ball!
      state.ball!
    end
  end

  describe "#steal!" do 
    it "allows the player to steal bases" do
      state.lineups.away.add 1
      state.lineups.away.add 2
      state.single!
      state.on_base(1).should eq 1
      state.move!(1,2,1)
      state.on_base(1).should eq 0
      state.on_base(2).should eq 1
      state.on_base(3).should eq 0
    end
    it "creates a stat for a steal for the player at bat" do
      state.lineups.away.add 42
      state.single!
      stat = state.move!(42,2,1)
      stat.user_id.should eq 42
      stat.category(:name).should eq "Steal"
      stat.game_id.should eq state.id      
    end
  end

  describe "#player_on_base" do
    let(:player) {FactoryGirl.create(:user)}
    it "gets the player object of the player on base" do
      state.lineups.away.add player.id
      state.lineups.away.add 2
      state.single!
      state.player_on_base(1).name.should eq player.name
    end
  end
end
