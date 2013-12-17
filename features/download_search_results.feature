Feature: Download search results as CSV
  In order to use data elsewhere
  As a user
  I want to download my search results as a CSV file

  Background:
    Given I have 30 specimens
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Download basic search results as CSV
    Given I am on the home page
    And I press "Go"
    And I click on "Export CSV"
    Then I should download a file with name "search_results.csv" and content type "text/csv; charset=utf-16 header=present"

  Scenario: Download an advanced search result as CSV
    Given I am on the Advanced Search page
    And I click on "Export CSV"
    Then I should download a file with name "search_results.csv" and content type "text/csv; charset=utf-16 header=present"