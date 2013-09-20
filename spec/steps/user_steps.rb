step "I click on Players" do
	click_on "Players"
end

step "I click New Player" do
  click_on "New Player"
end

step "I name the user :name" do |name|
  fill_in "Name", with: name
  fill_in "Email", with: "example@example.com"
  click_button "Create User"
end

step "I see the user called :name" do |name|
  page.should have_content name
end
