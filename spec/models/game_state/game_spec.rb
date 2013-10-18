require 'spec_helper'

describe GameState::Game do
  let(:state) { GameState::Game.new(FactoryGirl.create(:game).id) }

  describe "#single" do
    it "moves the player at bat to first base" do
      state.add_to_lineup(1)
      state.add_to_lineup(2)
      state.lineup_to_bases
      state.at_bat.should eq 1
      state.single!
      state.at_bat.should eq 2
      state.on_base(1).should eq 1
    end
    it "resets balls and strikes" do
      state.strike!
      state.ball!
      state.single!
      state.balls.should eq 0
      state.strikes.should eq 0
    end
  end

  describe "#double" do
    it "moves the player at bat to second base" do
      state.add_to_lineup(1)
      state.add_to_lineup(2)
      state.lineup_to_bases
      state.at_bat.should eq 1
      state.double!
      state.at_bat.should eq 2
      state.on_base(1).should eq 0
      state.on_base(2).should eq 1
    end
    it "moves player two bases foward" do
      state.add_to_lineup(1)
      state.add_to_lineup(2)
      state.add_to_lineup(3)
      state.lineup_to_bases
      state.single!
      state.double!
      state.on_base(1).should eq 0
      state.on_base(2).should eq 2
      state.on_base(3).should eq 1
    end
    it "resets balls and strikes" do
      state.strike!
      state.ball!
      state.double!
      state.balls.should eq 0
      state.strikes.should eq 0
    end
  end

  describe "#triple" do
    it "moves the player at bat to third base" do
      state.add_to_lineup(1)
      state.add_to_lineup(2)
      state.lineup_to_bases
      state.at_bat.should eq 1
      state.triple!
      state.at_bat.should eq 2
      state.on_base(1).should eq 0
      state.on_base(2).should eq 0
      state.on_base(3).should eq 1
    end
    it "moves player three bases foward" do
      state.add_to_lineup(1)
      state.add_to_lineup(2)
      state.add_to_lineup(3)
      state.lineup_to_bases
      state.single!
      state.triple!
      state.on_base(1).should eq 0
      state.on_base(2).should eq 0
      state.on_base(3).should eq 2
      state.on_base(4).should eq 1
    end
    it "resets balls and strikes" do
      state.strike!
      state.ball!
      state.triple!
      state.balls.should eq 0
      state.strikes.should eq 0
    end
  end

  describe "#out!" do
    it "increments the out count on a fresh game" do
      state.out!
      state.outs.should eq 1
    end

    it "calls next_inning after 3 outs" do
      state.should_receive(:next_inning!).once
      state.out!
      state.out!
      state.out!
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
      state.should_receive(:out!).once
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
      state.add_to_lineup(1)
      state.add_to_lineup(2)
      state.lineup_to_bases
      state.single!
      state.on_base(1).should eq 1
      state.steal!(1)
      state.on_base(1).should eq 0
      state.on_base(2).should eq 1
      state.on_base(3).should eq 0
      state.steal!(1)
      state.on_base(1).should eq 0
      state.on_base(2).should eq 0
      state.on_base(3).should eq 1
    end
  end

  describe "#player_on_base" do
    let(:player) {FactoryGirl.create(:user)}
    it "gets the player object of the player on base" do
      state.add_to_lineup(player.id)
      state.add_to_lineup(2)
      state.lineup_to_bases
      state.single!
      state.player_on_base(1).name.should eq player.name
    end
  end
end
