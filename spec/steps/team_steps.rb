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
  click_button "Create Player"
end

step "The player should be added to the team" do
  page.should have_content @player.name
end


step "The Player is on the Team" do
  @p = Player.new
  @p.user_id = @player.id
  @p.team_id = @team.id
  @p.save
end

step "A user is on the team page" do
  visit team_path(@team)
end

step "A user changes the player's jersey number" do
  @jersey_number = 1 + rand(10)
  find_by_id("edit_player_#{@p.id}_number").click
  bip_text @p, :player_number, @jersey_number.to_s
  page.evaluate_script 'jQuery.active == 0'
end 

step "The user can see the new jersey number" do
  page.should have_content @jersey_number
end
