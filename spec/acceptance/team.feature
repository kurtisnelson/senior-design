Feature: Teams can be created, named, and have players
        Scenario: A new team can be created
                 When I visit the home page
                 And I click on Teams
                 And I click New Team
                 And I name the team "Broncos"
                 And I create the team
                 Then I see the team called "Broncos"
        @javascript
        Scenario: A player can be added to a team
                Given I create the player "Antonio Freeman"
                When I visit the home page
                And I click on Teams
                And I click New Team
                And I name the team "Packers"
                And I add "Antonio Freeman" to the team
                And I create the team
                And I show the team
                Then I see the player "Antonio Freeman" on the team
                
