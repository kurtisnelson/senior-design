step "I visit the home page" do
  visit root_path
end

step "I visit the Games page" do
  visit '/games'
  binding.pry
end
