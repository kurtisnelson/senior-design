require 'spec_helper'

describe Team do
  describe "#add_player" do
  	let(:team) {FactoryGirl.create(:team)}
  	let(:user) {FactoryGirl.create(:user)}
  	it "adds a user to a team" do 
  		team.add_player(user.id)
  		team.players.count.should eq 1
  		user.teams.count.should eq 1
  		team.players.first.user.id.should eq user.id
  		user.players.first.team.id.should eq team.id
  	end
  end
end
