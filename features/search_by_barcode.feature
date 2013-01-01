Feature: Search using barcode
  In order to quickly find a specimen
  As a user
  I want to search by scanning a barcode on a label

  Background:
    Given I have a specimen
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Search for valid specimen using NE123 format
    Given I am on the home page
    When I do a quick search for "NE%current_specimen%"
    Then I should be on the specimen page

  Scenario: Search for valid specimen using NE123.456 format
    Given I am on the home page
    When I do a quick search for "NE%current_specimen%.456"
    Then I should be on the specimen page

  Scenario: Search for non existent specimen
    Given I am on the home page
    When I do a quick search for "NE999999999"
    Then I should see "No specimen was found with accession number 999999999"

  Scenario: Search with text in string
    Given I am on the home page
    When I do a quick search for "NE123a"
    Then I should see "No specimen was found for text search 'NE123a'"

