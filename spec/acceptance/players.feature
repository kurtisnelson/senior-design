Feature: A user can view a player's stats

  Scenario: A user can view a player's average on the player page
    Given I am a user
    And I am part of a team
    And I played in a game with the team
    And I scored a home run in the game
    And I had three outs in the game
    When I visit the team's page
    And I click on my name
    Then I can see my average updated

  Scenario: A user can view a player's homeruns on the player page
    Given I am a user
    And I am part of a team
    And I played in a game with the team
    And I scored a home run in the game
    When I visit the team's page
    And I click on my name
    Then I can see my homerun updated

  Scenario: A user can view a player's RBI on the player page
    Given I am a user
    And I am part of a team
    And I played in a game with the team
    And I had three RBIs
    When I visit the team's page
    And I click on my name
    Then I can see my RBI updated

  Scenario: A user can view a player's OBP on the player page
    Given I am a user
    And I am part of a team
    And I played in a game with the team
    And I scored a home run in the game
    And I had three outs in the game
    And I had one walk in the game
    When I visit the team's page
    And I click on my name
    Then I can see my OBP updated