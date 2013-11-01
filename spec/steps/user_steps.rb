step "A user is not logged in" do
  logout
end

step "A user visits the home page" do 
  visit root_path
end

step "The user can see the Sign In button" do 
  page.should have_content "Sign In"
end

step "The user logs in" do
  @user = FactoryGirl.build(:user)
  login_as @user
  visit root_path
end

step "The user can see his name" do
  page.should have_content @user.name
end

step "A user is logged in" do
  @user = FactoryGirl.build(:user)
  login_as @user
  visit root_path
end

step "A user clicks log out" do
  click_on "Sign Out"
end

step "The user can see the Sign In button" do
  page.should have_content "Sign In"
end