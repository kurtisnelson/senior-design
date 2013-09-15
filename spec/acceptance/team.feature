Feature: Teams can be created, and named
        Scenario: A new team can be created
                 When I visit the home page
                 And I click on Teams
                 And I click New Team
                 And I name the team "Broncos"
                 Then I see the team called "Broncos"
