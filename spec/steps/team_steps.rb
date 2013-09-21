step "I click on Teams" do
	click_on "Teams"
end

step "I click New Team" do
  click_on "New Team"
end

step "I name the team :name" do |name|
  fill_in "Name", with: name
end

step "I create the team" do
  click_button "Create Team"
end

step "I create the player :name" do |name_entry|
  FactoryGirl.create(:user, name:name_entry)
end

step "I see the team called :name" do |name|
  page.should have_content name
end

step "I create the team :name" do |name|
	FactoryGirl.create(:team, name:name)
end

step "I click on all teams" do
  click_on "All Teams"
end

step "I add :name to the team" do |name|
  check(name)
end

step "I see the player :name on the team" do |name|
  page.should have_content name
end

step "I show the team" do
  click_on "Show"
end

step "I click edit" do
  click_on "Edit"
end

step "I uncheck :name" do |name|
  uncheck(name)
end

step "I update the team" do 
  click_button "Update Team"
end

step "I don't see the player :name on the team" do |name|
  page.should have_no_content name
end
