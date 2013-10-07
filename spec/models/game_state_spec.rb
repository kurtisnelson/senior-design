require 'spec_helper'

describe GameState do
  let(:state) { GameState.new(0) }

  describe "#single" do
    it "moves the player at bat to first base" do
      state.add_to_lineup(0)
      state.add_to_lineup(1)
      state.lineup_to_bases
      ->{state.single!}.should change(state, :at_bat).from(0).to(1)
    end
    it "resets balls and strikes" do
      state.strike!
      state.ball!
      state.single!
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
end
