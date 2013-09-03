Feature: Athletes can be created, and named
        Scenario: A new athlete can be created
                 When I visit the home page
                 And I click new athlete
                 And I name the athlete "Bob"
                 Then I see the athlete called "Bob"
