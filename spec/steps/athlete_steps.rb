step "I click on Athletes" do
	click_on "Athletes"
end

step "I click New Athlete" do
  click_on "New Athlete"
end

step "I name the athlete :name" do |name|
  fill_in "Name", with: name
  click_button "Create Athlete"
end

step "I see the athlete called :name" do |name|
  page.should have_content name
end
