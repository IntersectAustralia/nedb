Feature: Labels
  In order to efficiently print a batch of labels
  As a user
  I want to generate printable labels from the advanced search results

  Background:
    Given I have item types Silica Gel, Photo, Fruit, Specimen sheet
    Given I have specimens
      | locality_description | vegetation       | tag        |
      | botanical gardens    | gum tree         | specimen 1 |
      | botany               | cactus           | specimen 2 |
      | royal national park  | tall gum, cactus | specimen 3 |
  # s1 has a det and some items that will generate labels
    And I have specimen "specimen 1"
    And "specimen 1" has a determination with string "abc"
    And "specimen 1" has an item of type "Specimen sheet"
  # s2 has a det but no items that will generate labels
    And I have specimen "specimen 2"
    And "specimen 2" has a determination with string "abc"
  # s3 has no det and items that will generate labels
    And I have specimen "specimen 3"
    And "specimen 3" has an item of type "Specimen sheet"
    And I have the usual profiles and permissions
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I am logged in as "super@intersect.org.au"

  Scenario: Error message shown where none will generate labels
    Given I am on the Advanced Search page
    When I fill in "search_vegetation_contains" with "cactus"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality            | Vegetation       |
      | botany              | cactus           |
      | royal national park | tall gum, cactus |
    When I follow "Print Labels"
    Then I should see "No labels to print for these specimens."

  Scenario: Labels produced where at least one specimen will generate labels
    Given I am on the Advanced Search page
    And I press "search_submit"
    When I follow "Print Labels"
    Then I should get a file with name "labels.pdf" and content type "application/pdf"
