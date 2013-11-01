Feature: A user can log onto Fenway
	
	Scenario: A user can see the sign in button
    Given A user is not logged in
    When A user visits the home page
    Then The user can see the Sign In button

  Scenario: A user can log in
    Given A user is not logged in
    When A user visits the home page
    And The user logs in
    Then The user can see his name

  Scenario: A user can log out
    Given A user is logged in
    When A user clicks log out
    Then The user can see the Sign In button
