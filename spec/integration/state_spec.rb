require 'spec_helper'

describe StateController do
	let(:game_state) {GameState::Game.new(FactoryGirl.create(:game).id)}
	describe "#show" do
		before :each do
			FactoryGirl.create_list(:user, 12)
			User.limit(9).each {|p| game_state.add_to_lineup p.id}
			game_state.lineup_to_bases
			game_state.outs = 40
			game_state.balls = 3
			game_state.strikes = 2
			get state_path(game_state.id)
			@state_json = JSON.parse(response.body)
		end

		it "returns a json Game" do
			@state_json['game']['id'].should eq game_state.id
		end
		it "returns relevant Users" do
			@state_json['players'].length.should eq 9	
		end
		it "contains balls, strikes, outs" do
			@state_json['game']['balls'].should eq 3
			@state_json['game']['strikes'].should eq 2
			@state_json['game']['outs'].should eq 40
		end
		it "contains a lineup and bases with User IDs" do
			@state_json['game']['bases'].should include User.first.id
			@state_json['game']['lineup'].should eq User.limit(9).pluck(:id).reverse[0..7]
		end
	end
end
