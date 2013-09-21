step "I click on Games" do
	click_on "Games"
end 

step "I click New Game" do
  click_on "New Game"
end

step "I generate a game called :name" do |name|
  FactoryGirl.create(:game, name:name)	
end

step "I create a game called :name" do |name|
  fill_in "Name", with: name
  fill_in "Location", with: "Home"
  click_button "Create Game"
end

step "I see the game called :name" do |name|
  page.should have_content name
end

step "I see a Home Team called :name" do |name|
  page.should have_content name
end

step "I see an Away Team called :name" do |name|
  page.should have_content name
end

step "I click All Games" do
	click_link "All Games"
end

step "I edit a game called :name" do |name|
	click_on "Edit"
end

step "I update Home Team to :name" do |name|
	select name, :from => "game_home_team_id"
end

step "I update Away Team to :name" do |name|
	select name, :from => "game_away_team_id"
end

step "I click Update Game" do
	click_on "Update Game"
end
