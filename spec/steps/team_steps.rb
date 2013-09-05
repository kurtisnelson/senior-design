step "I click new team" do
  click_on "New Team"
end

step "I name the team :name" do |name|
  fill_in "Name", with: name
  click_button "Create Team"
end

step "I see the team called :name" do |name|
  page.should have_content name
end
