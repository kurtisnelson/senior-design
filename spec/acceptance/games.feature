Feature: Games can be created, updated, and scheduled
  
  Scenario: A new game can be created
		When I visit the home page
		And I click on Games
		And I click New Game
		And I create a game called "fun"
		Then I see the game called "fun"

	Scenario: All games are listed on the index page
		When I visit the home page
		And I click on Games
		And I click New Game
		And I create a game called "fun"
		And I visit the home page
		Then I see the game called "fun"
@javascript
	Scenario: A game can update a Home Team and Away Team
		Given I create the team "Georgia Tech"
		Given I create the team "UNC"
		When I visit the Games page
		And I edit a game called "fun"
		And I update home team
		And I update away team
		Then I see the game called "fun"
