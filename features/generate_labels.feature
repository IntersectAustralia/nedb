Feature: Labels
  In order to track my physical specimens
  As a user
  I want to generate printable labels

  Background:
    Given I have specimen "specimen 1"
    And I have specimen "specimen 2"
    And I have item types Silica Gel, Photo, Fruit, Specimen sheet
    And "specimen 1" has an item of type "Specimen sheet"
    And I have the usual profiles and permissions
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I am logged in as "super@intersect.org.au"

  Scenario: Specimen with no determination
    Given I am on the specimen page for "specimen 1"
    When I follow "Print Labels"
    Then I should see "Labels cannot be generated for this specimen as it does not have a determination."
    And I should be on the specimen page for "specimen 1"

  Scenario: Specimen with no specimen sheets/fruits/replicates
    Given "specimen 2" has a determination with string "abc"
    And I am on the specimen page for "specimen 2"
    When I follow "Print Labels"
    Then I should see "There are no labels to generate for this specimen. Try adding some specimen sheets or fruit items."
    And I should be on the specimen page for "specimen 2"

  Scenario: Specimen with labels
    Given "specimen 1" has a determination with string "abc"
    Given I am on the specimen page for "specimen 1"
    When I follow "Print Labels"
    Then I should get a file with name "labels.pdf" and content type "application/pdf"
