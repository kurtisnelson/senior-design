step "A users visits the home page" do 
  visit root_path
end

step "He clicks on Teams" do
  click_on "TEAMS"
end

step "He clicks on Create A Team" do 
  click_on "Create a Team"
end 

step "He names the team :name" do |name|
  fill_in "Name", with: name
end 

step "He creates the team" do 
  click_button "Create Team"
end

step "I see the team called :name" do |name|
  page.should have_content name
end


step "A Player exists" do 
  @player = FactoryGirl.create(:user)
end

step "A Team exists" do
  @team = FactoryGirl.create(:team)
end

step "A user is on the team page" do
  visit team_path(@team)
end

step "He clicks on Add Player" do
  click_on "Add Player"
end

step "Fills in name with the player's name" do
  fill_in "player[user][name]", with: @player.name
end

step "Clicks add player" do
 page.execute_script("$('#new_player').submit();")
end

step "The player should be added to the team" do
  page.should have_content @player.name
end

