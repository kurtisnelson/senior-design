Feature: Teams can be created, named, and have players
        Scenario: A new team can be created
                 When I visit the home page
                 And I click on Teams
                 And I click New Team
                 And I name the team "Broncos"
                 Then I see the team called "Broncos"
        @javascript
        Scenario: A new team can have players
                Given I create a user "Ryan"
                When I visit the home page
                And I click on Teams
                And I click on all teams
                And I select the given team
                Then I see "Ryan"
        
