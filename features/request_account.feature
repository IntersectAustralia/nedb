Feature: Request an account
  In order to use the system
  As a user
  I want to request an account
  
  Background:
    Given I have no users
    Given I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity   | action              | profiles                          |
      | Specimen | request_deaccession | Superuser, Administrator          |
      | Specimen | approve_deaccession | Superuser                         |
      | Specimen | unflag_deaccession  | Superuser                         |
      | Specimen | view_deaccessioned  | Superuser                         |
      | Specimen | read                | Superuser, Administrator, Student |
    And I have a user "diego.alonso@intersect.org.au" with profile "Superuser"

  Scenario: Request account
    Given I am on the request account page
    When I fill in "Email" with "georgina@intersect.org.au"
    And I fill in "Password" with "paS$w0rd"
    And I fill in "Confirm password" with "paS$w0rd"
    And I select "Ms" from "Title"
    And I fill in "First name" with "Fred"
    And I fill in "Last name" with "Bloggs"
    And I press "Submit Request"
    Then I should see "Thanks for requesting an account. You will receive an email when your request has been approved."
    And I should be on the login page
    
  Scenario: Requesting an account with mismatched password confirmation should be rejected
    Given I am on the request account page
    When I fill in "Email" with "georgina@intersect.org.au"
    And I fill in "Password" with "paS$w0rd"
    And I fill in "Confirm password" with "password"
    And I select "Ms" from "Title"
    And I fill in "First name" with "Fred"
    And I fill in "Last name" with "Bloggs"
    And I press "Submit Request"
    Then I should see "Password doesn't match confirmation"
    
  Scenario: Newly requested account should not be able to log in yet
    Given I am on the request account page
    And I fill in "Email" with "georgina@intersect.org.au"
    And I fill in "Password" with "paS$w0rd"
    And I fill in "Confirm password" with "paS$w0rd"
    And I select "Ms" from "Title"
    And I fill in "First name" with "Fred"
    And I fill in "Last name" with "Bloggs"
    And I press "Submit Request"
    And I am on the login page
    When I fill in "Email" with "georgina@intersect.org.au"
    And I fill in "Password" with "paS$w0rd"
    And I press "Log in"
    Then I should see "Your account is not active."
    And I should be on the login page
    
