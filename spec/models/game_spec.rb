require 'spec_helper'

describe Game do
  let(:game) { FactoryGirl.build_stubbed(:game) }
  describe "#out" do
    it "increments the out count on a new game" do
      game.out
      game.out_count.should eq 1
    end

    it "calls next_inning after 3 outs" do
      game.should_receive(:next_inning).once
      game.out
      game.out
      game.out
    end
  end

  describe "#next_inning" do
    it "resets outs" do
      game.out_count = 100
      game.next_inning
      game.out_count.should eq 0
    end
  end

  describe "#strike" do
    it "increments the strike count on a new game" do
      game.strike
      game.strike_count.should eq 1
    end

    it "calls out after 3 strikes" do
      game.should_receive(:out).once
      game.strike
      game.strike
      game.strike
    end
  end

  describe "#ball" do
    it "calls walk after 4 balls" do
      game.should_receive(:walk).once
      game.ball
      game.ball
      game.ball
      game.ball
    end
  end
end
