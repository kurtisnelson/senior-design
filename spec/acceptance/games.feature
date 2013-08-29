Feature: Games can be created, updated, and scheduled
        Scenario: A new game can be created
                When I visit the home page
                And I click new game
                And I create a game called "fun"
                Then I see the game called "fun"
