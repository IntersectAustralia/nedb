Feature: Permissions to view specimens
  In order to make the system usable
  As the system owner
  I want to restrict access to some specimens

  Background:
    Given I have the usual profiles and permissions
    And I have enough static data to create specimens
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I have a user "raul@intersect.org.au" with profile "Student"
    And I have specimen "specimen 1" with status ""
    And I have specimen "specimen 2" with status "DeAccReq"
    And I have specimen "specimen 3" with status "DeAcc"
    And "specimen 1" has a determination with string "bcd"
    And "specimen 2" has a determination with string "abc"
    And "specimen 3" has a determination with string "abcd"
    And "specimen 3" has a confirmation

  Scenario: Superuser can find all specimens by searching on id
    Given I am logged in as "georgina@intersect.org.au"
    And I am on the home page
    When I search for "specimen 1" by id
    Then I should be on the specimen page for "specimen 1"
    When I search for "specimen 2" by id
    Then I should be on the specimen page for "specimen 2"
    When I search for "specimen 3" by id
    Then I should be on the specimen page for "specimen 3"

  Scenario: Student can't find deaccessioned specimens by searching on id (but can find others)
    Given I am logged in as "raul@intersect.org.au"
    And I am on the home page
    When I search for "specimen 1" by id
    Then I should be on the specimen page for "specimen 1"
    When I search for "specimen 2" by id
    Then I should be on the specimen page for "specimen 2"
    When I search for "specimen 3" by id
    Then I should get a security error "You do not have permissions to view this specimen."

  Scenario: Superuser can find all specimens when doing a free text search
    Given I am logged in as "georgina@intersect.org.au"
    And I am on the home page
    When I do a quick search for "bc"
    Then I should see "Search Results"
    And the search result table should contain
      | Species |
      | bcd     |
      | abc     |
      | abcd    |

  Scenario: Superuser can find a de-accessioned specimen when free text search returns just one result
    Given I am logged in as "georgina@intersect.org.au"
    And I am on the home page
    When I do a quick search for "abcd"
    Then I should be on the specimen page for "specimen 3"

  Scenario: Student can't find de-accessioned specimens when doing a free text search
    Given I am logged in as "raul@intersect.org.au"
    And I am on the home page
    When I do a quick search for "bc"
    Then I should see "Search Results"
    And the search result table should contain
      | Species |
      | bcd     |
      | abc     |

  Scenario: Student can't find a de-accessioned specimen when free text search returns just one result
    Given I am logged in as "raul@intersect.org.au"
    And I am on the home page
    When I do a quick search for "abcd"
    Then I should be on the home page
    And I should see "No specimen was found for text search 'abcd'"

  Scenario: Student can find a regular specimen when free text search returns just one result
    Given I am logged in as "raul@intersect.org.au"
    And I am on the home page
    When I do a quick search for "abc"
    Then I should be on the specimen page for "specimen 2"

  Scenario: Student can't do anything on deaccessioned specimens
    Given I am logged in as "raul@intersect.org.au"
    Then I should get the following security outcomes
      | page                                           | outcome | message                                             |
      | the specimen page for "specimen 3"             | error   | You do not have permissions to view this specimen.  |
      | the edit specimen page for "specimen 3"        | error   | You do not have permissions to perform this action. |
      | the edit replicates page for "specimen 3"      | error   | You do not have permissions to perform this action. |
      | the view determination page for "specimen 3"   | error   | You do not have permissions to view this specimen.  |
      | the create determination page for "specimen 3" | error   | You do not have permissions to view this specimen.  |
      | the edit determination page for "specimen 3"   | error   | You do not have permissions to view this specimen.  |
      | the create confirmation page for "specimen 3"  | error   | You do not have permissions to view this specimen.  |
      | the edit confirmation page for "specimen 3"    | error   | You do not have permissions to view this specimen.  |

  Scenario: Superuser can do stuff on deaccessioned specimens
    Given I am logged in as "georgina@intersect.org.au"
    Then I should get the following security outcomes
      | page                                           | outcome | message |
      | the specimen page for "specimen 3"             | ok      |         |
      | the edit specimen page for "specimen 3"        | ok      |         |
      | the edit replicates page for "specimen 3"      | ok      |         |
      | the view determination page for "specimen 3"   | ok      |         |
      | the create determination page for "specimen 3" | ok      |         |
      | the edit determination page for "specimen 3"   | ok      |         |
      | the create confirmation page for "specimen 3"  | ok      |         |
      | the edit confirmation page for "specimen 3"    | ok      |         |
