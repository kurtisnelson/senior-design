step "I click on Users" do
	click_on "Users"
end

step "I click New User" do
  click_on "New User"
end

step "I name the user :name" do |name|
  fill_in "Name", with: name
  click_button "Create User"
end

step "I see the user called :name" do |name|
  page.should have_content name
end
