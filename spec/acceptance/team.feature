Feature: Teams can be created, named, and have players
  
  Scenario: A new team can be created
    Given A users visits the home page
    And He clicks on Teams
    When He clicks on Create A Team
    And He names the team "Broncos"
    And He creates the team
    Then I see the team called "Broncos"

  Scenario: A Team can add a player
    Given A Player exists
    And A Team exists
    And A user is on the team page
    When He clicks on Add Player
    And Fills in name with the player's name
    And Clicks add player
    Then The player should be added to the team

  @javascript
  Scenario: A Player's jersey number can be updated
    Given A Player exists
    And A Team exists
    And The Player is on the Team
    And A user is on the team page
    When A user changes the player's jersey number
    Then The user can see the new jersey number