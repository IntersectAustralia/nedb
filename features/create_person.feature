Feature: Create people
  In order to add collectors
  As a user 
  I want to create people

  Background: 
    Given I have no people
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the home page
    When I follow "Admin"
    And I follow "Manage People"
    Then I should see "People"

  Scenario: Create a valid person
    When I follow "Create New Person"
    And I fill in "First name" with "Jack"
    And I fill in "Middle name" with "Garry"
    And I fill in "Last name" with "Black"
    And I fill in "Initials" with "J.G."
    And I select "Please select" from "Herbarium"
    And I fill in "Address" with "42 Lombard st, Fairfield, 2165"
    And I fill in "Email" with "jack@hotmail.com"
    And I press "Create Person"
    Then I should see "Person was successfully created."
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Display name | Herbarium Code | Email            | 
      | Jack       | Garry       | Black     | J.G. Black    |                | jack@hotmail.com |
