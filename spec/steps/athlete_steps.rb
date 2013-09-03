step "I click new athlete" do
  click_on "New Athlete"
end

step "I name the athlete :name" do |name|
  fill_in "Name", with: name
  click_button "Create Athlete"
end

step "I see the athlete called :name" do |name|
  page.should have_content name
end
