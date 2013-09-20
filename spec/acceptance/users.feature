Feature: Users can be created, and named
	
	Scenario: A new user can be created
		When I visit the home page
		And I click on Players
		And I click New Player
		And I name the user "Bob"
		Then I see the user called "Bob"
