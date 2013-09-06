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
