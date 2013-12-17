Feature: Edit my details
  In order to keep my details up to date
  As a user
  I want to edit my details
  
  Background:
    Given I have no users
    Given I have a user "georgina@intersect.org.au"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Edit my information
    Given I am on the home page
    When I follow "Edit My Details"
    And I select "Ms" from "Title"
    And I fill in "First name" with "Fred"
    And I fill in "Last name" with "Bloggs"
    And I fill in "Other initials" with "C"
    And I select "HDR postgraduate student" from "Position"
    And I fill in "Supervisor" with "Bob Smith"
    And I fill in "Group, School, Institution" with "University of Sydney"
    And I fill in "Address" with "309 Kent St"
    And I fill in "Telephone" with "02 8333 3333"
    And I press "Update"
    Then I should see "Your account details have been successfully updated."
    And I should be on the home page
    And I follow "Edit My Details"
    And the "First name" field should contain "Fred"

  Scenario Outline: Editing my information with invalid data
    Given I am on the home page
    When I follow "Edit My Details"
    And I fill in "<field>" with "<value>"
    And I press "Update"
    Then I should see /\d error(s)? need to be corrected before this record can be saved\./
    And the "<field>" field should have the error "<error>"

  Examples:
    | field      | value | error          |
    | First name |       | can't be blank |
    | Last name  |       | can't be blank |
