step "I click new game" do
  click_on "New Game"
end

step "I create a game called :name" do |name|
  fill_in "Name", with: name
  fill_in "Location", with: "Home"
  click_button "Create Game"
end

step "I see the game called :name" do |name|
  page.should have_content name
end
