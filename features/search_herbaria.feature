Feature: Search
  In order to quickly find a herbarium
  As an administrator
  I want to use the search option

  Background:
    Given I have herbaria
      | code | name                     |
      | NSW  | NSW Botanical Gardens    |
      | WOLL | University of Wollongong |
      | SCU  | DNA Bank                 |
      | UNC  | University of Newcastle  |
    And I have the usual profiles and permissions
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"

  Scenario: Search for valid herbarium by code as an administrator
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    And I follow "Manage Herbaria"
    When I fill in "Search" with "NSW" within the main content
    And I press "Go"
    Then I should be on the list herbaria page for "NSW"
    And the search result table should contain
      | Code | Name                  | Actions |
      | NSW  | NSW Botanical Gardens |         |
    And I should see "Found 1 matching herbarium"

  Scenario: Search for valid herbarium by code as a superuser
    Given I am logged in as "super@intersect.org.au"
    And I am on the admin page
    And I follow "Manage Herbaria"
    When I fill in "Search" with "NSW" within the main content
    And I press "Go"
    Then I should be on the edit herbarium page for "NSW"
    And I should see "Found 1 matching herbarium"


  Scenario Outline: Search for non existing herbarium
    Given I am logged in as "<login>"
    And I am on the admin page
    And I follow "Manage Herbaria"
    When I fill in "Search" with "abc" within the main content
    And I press "Go"
    Then I should see "No herbaria was found for text search 'abc'"

  Examples:
    | login                  |
    | super@intersect.org.au |
    | admin@intersect.org.au |

  Scenario Outline: Search without entering a search term returns all herbaria
    Given I am logged in as "<login>"
    And I am on the admin page
    And I follow "Manage Herbaria"
    When I fill in "Search" with "" within the main content
    And I press "Go"
    Then I should see "List of Herbaria"
    Then I should see "Showing all 4 herbaria."
    And the search result table should contain
      | Code | Name                     |
      | NSW  | NSW Botanical Gardens    |
      | SCU  | DNA Bank                 |
      | UNC  | University of Newcastle  |
      | WOLL | University of Wollongong |

  Examples:
    | login                  |
    | super@intersect.org.au |
    | admin@intersect.org.au |

  Scenario: Search that returns a single search result redirects to the specimen page
    Given I am logged in as "super@intersect.org.au"
    And I am on the admin page
    And I follow "Manage Herbaria"
    When I fill in "Search" with "WOLL" within the main content
    And I press "Go"
    Then I should be on the edit herbarium page for "WOLL"
    And I should see "Found 1 matching herbarium"

  Scenario: Search that returns multiple search results redirects to the result set page
    Given I am logged in as "super@intersect.org.au"
    And I am on the admin page
    And I follow "Manage Herbaria"
    When I fill in "Search" with "University" within the main content
    And I press "Go"
    Then I should see "List of Herbaria"
    And I should see "Found 2 matching herbaria"
    And the search result table should contain
      | Code | Name                     |
      | UNC  | University of Newcastle  |
      | WOLL | University of Wollongong |
