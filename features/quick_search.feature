Feature: Quick Search
  In order to quickly find a specimen
  As a user
  I want to use the quick search option

  Background:
    Given I have specimen "a"
    And "a" has a determination with string "searchable"
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Search for valid specimen
    Given I am on the home page
    When I do a quick search by id for specimen "a"
    Then I should be on the specimen page for "a"

  Scenario: Search for non existent specimen
    Given I am on the home page
    When I do a quick search for "9999999"
    Then I should see "No specimen was found with accession number 9999999"

  Scenario: Search for non existing specimen
    Given I am on the home page
    When I do a quick search for "abc"
    Then I should see "No specimen was found for text search 'abc'"

  Scenario: Search without entering a search term returns all specimens
    Given I have specimen "b"
    And "b" has a determination with string "searchable"
    Given I am on the home page
    When I do a quick search for ""
    Then I should see "Search Results"
    And the search result table should contain
      | Species    |
      | searchable |
      | searchable |
    And I should see "Showing all 2 specimens."

  Scenario: Search that returns a single search result redirects to the specimen page
    Given I am on the home page
    When I do a quick search for "searchable"
    Then I should be on the specimen page for "a"

  Scenario: Search that returns multiple search results redirects to the result set page
    Given I have specimen "b"
    And "b" has a determination with string "searchable"
    And I am on the home page
    When I do a quick search for "searchable"
    Then I should see "Search Results"
    And the search result table should contain
      | Species    |
      | searchable |
      | searchable |

  Scenario: If multiple search results, the last determination of each specimen is shown in the table
    Given I have specimen "b"
    And "b" has a determination with string "other" on "21/11/2010"
    And "b" has a determination with string "searchable" on "22/11/2010"
    And I am on the home page
    When I do a quick search for "searchable"
    Then I should see "Search Results"
    And the search result table should contain
      | Species    |
      | searchable |
      | searchable |

  Scenario: We only search inside the last determination
    Given I have specimen "b"
    And "b" has a determination with string "other" on "22/11/2010"
    And "b" has a determination with string "searchable" on "21/11/2010"
    And I am on the home page
    When I do a quick search for "searchable"
    Then I should be on the specimen page for "a"
