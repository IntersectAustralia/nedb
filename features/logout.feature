Feature: Logging Out
  In order to keep the system secure
  As a user
  I want to logout
  
  Background:
    Given I have a user "georgina@intersect.org.au"
    And I am logged in as "georgina@intersect.org.au"
  
  Scenario: Successful logout
    Given I am on the admin page
    When I follow "Logout"
    Then I should see "Logged out successfully."
    And I should be on the home page

  Scenario: Logged out user can't access secure pages
    Given I am on the admin page
    And I follow "Logout"
    When I am on the admin page
    Then I should be on the login page
    And I should see "You need to log in before continuing."

