Feature: A user can login using Google OAuth
  @javascript
  Scenario: A user can click the login button
    When I visit the home page
    And I click the button Sign in with Google
    Then I can see the email field
