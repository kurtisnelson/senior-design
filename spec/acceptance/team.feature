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