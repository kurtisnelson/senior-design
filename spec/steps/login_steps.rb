step "I click the button Sign in with Google" do
  click_on "Sign in with Google"
end

step "I can see the email field" do
  page.should have_content "Email"
end
