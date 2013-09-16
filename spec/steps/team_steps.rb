step "I click on Teams" do
	click_on "Teams"
end

step "I click New Team" do
  click_on "New Team"
end

step "I name the team :name" do |name|
  fill_in "Name", with: name
  click_button "Create Team"
end

step "I see the team called :name" do |name|
  page.should have_content name
end

step "I create a user :name" do |name|
  @user=FactoryGirl.create :user_with_team, name: name
end

step "I click on all teams" do
  click_on "All Teams"
end

step "I select the given team" do
    click_on "Show"
end

step "I see the user :name" do |name| 
  page.should have_content name
end
