Feature: Logging In
  In order to use the system
  As a user
  I want to login
  
  Background:
    Given I have a user "georgina@intersect.org.au"
  
  Scenario: Successful login
    Given I am on the login page
    When I fill in "Email" with "georgina@intersect.org.au"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Logged in successfully."
    And I should be on the home page

  Scenario: Should be redirected to the login page when trying to access a secure page
    Given I am on the admin page
    Then I should see "You need to log in before continuing."
    And I should be on the login page

  Scenario: Should be redirected to requested page after logging in
    Given I am on the admin page
    When I fill in "Email" with "georgina@intersect.org.au"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Logged in successfully."
    And I should be on the admin page

  Scenario: Failed login due to missing both email and password
    Given I am on the login page
    When I press "Log in"
    Then I should see "Invalid email or password."
    And I should be on the login page

  Scenario: Failed login due to missing email
    Given I am on the login page
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Invalid email or password."
    And I should be on the login page

  Scenario: Failed login due to missing password
    Given I am on the login page
    When I fill in "Email" with "georgina@intersect.org.au"
    And I press "Log in"
    Then I should see "Invalid email or password."
    And I should be on the login page

  Scenario: Failed login due to invalid username
    Given I am on the login page
    When I fill in "Email" with "asdf@intersect.org.au"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Invalid email or password."
    And I should be on the login page

  Scenario: Failed login due to incorrect password
    Given I am on the login page
    When I fill in "Email" with "georgina@intersect.org.au"
    And I fill in "Password" with "blah"
    And I press "Log in"
    Then I should see "Invalid email or password."
    And I should be on the login page


