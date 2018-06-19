@signup @core
Feature: SignUp
  In order to check MyCompany can register users
  As a user
  I want to register a demo user

  @javascript
  Scenario: Can access to the Login page
    Given I am on the signup page
    Then I should see "Sign Up" text
    And I type "Name Surname" in "input-name" field
    And I type "user@email.com" in "input-email" field
    And I type "Passw0rd" in "input-password" field
    And I type "Passw0rd" in "input-re-password" field
    #And I click on CSS class "custom-checkbox"
    #And I click on text "Register"
