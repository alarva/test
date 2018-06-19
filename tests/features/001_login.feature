@login @core
Feature: Login
  In order to check MyCompany can log-in users
  As a user
  I want to login a demo user

  @javascript
  Scenario: Can access to the Login page
    Given I am on the login page
    #And I wait for 1 seconds
    Then I should see "Sign In" text
    And I type "user@email.com" in "input-email" field
    And I type "password" in "input-password" field
    And I press "Sign In"
