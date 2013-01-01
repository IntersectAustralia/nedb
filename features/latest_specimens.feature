Feature: View Latest 40 Specimens
  In order to quickly view new specimens added to the system
  As a user
  I want to use the latest 40 option

  Background:
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Should not see more than 40 specimens
    Given I have 50 specimens
    And I am on the home page
    And I follow "Latest 40"
    And I should see "Showing latest 40 specimens in descending order"
    Then I should not see "BotDiv 1."
    Then I should not see "BotDiv 10."
    Then I should see "BotDiv 11."
    Then I should see "BotDiv 50."

  Scenario: Should not see more than 40 specimens
    Given I have 30 specimens
    And I am on the home page
    And I follow "Latest 40"
    And I should see "Showing latest 40 specimens in descending order"
    Then I should see "BotDiv 1."
    Then I should see "BotDiv 30."





