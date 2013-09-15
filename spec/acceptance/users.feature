Feature: Users can be created, and named
        Scenario: A new user can be created
                 When I visit the home page
                 And I click on Users
                 And I click New User
                 And I name the user "Bob"
                 Then I see the user called "Bob"
