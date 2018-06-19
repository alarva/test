@dashboard @core
Feature: DashBoard
  In order to check MyCompany can display DashBoard
  As a user
  I want to check if it is displayed

  @javascript
  Scenario: Can access to the Login page
    Given I am on the dashboard page
    Then I should see "MyCompany" text

    And I click on CSS class "nb-home"

    And I click on CSS class "nb-keypad"
    And I click on CSS class "nb-keypad"

    And I click on CSS class "nb-compose"
    And I click on CSS class "nb-compose"

    And I scroll down
    Then I should see "by Akveo 2017" text
