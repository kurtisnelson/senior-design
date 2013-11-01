
step "I generate a game called :name" do |name|
  FactoryGirl.create(:game, name:name)	
end

step "I create a game called :name" do |name|
  fill_in "Name", with: name
  fill_in "Location", with: "Home"
  click_button "Create Game"
end
