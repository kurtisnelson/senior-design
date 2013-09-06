Feature: Athletes can be created, and named
		@javascript
        Scenario: A new athlete can be created
                 When I visit the home page
                 And I click on Athletes
                 And I click New Athlete
                 And I name the athlete "Bob"
                 Then I see the athlete called "Bob"
