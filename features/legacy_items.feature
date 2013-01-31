Feature: Handling legacy data
  In order to handle legacy data in the system
  As a user
  I want to edit legacy records

  Background:
    Given I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity        | action                 | profiles                 |
      | Specimen      | read                   | Superuser, Administrator |
      | Specimen      | create                 | Superuser                |
      | Specimen      | update                 | Superuser                |
      | Specimen      | update_replicates      | Superuser                |
      | Specimen      | update_specimen_images | Superuser                |
      | Specimen      | add_item               | Superuser                |
      | Specimen      | view_needing_review    | Superuser, Administrator |
      | Item          | destroy                | Superuser                |
      | Determination | read                   | Superuser, Administrator |
      | Determination | create                 | Superuser                |
      | Determination | update                 | Superuser                |
      | SpecimenImage | read                   | Superuser, Administrator |
      | SpecimenImage | create                 | Superuser                |
      | SpecimenImage | update                 | Superuser                |
      | SpecimenImage | destroy                | Superuser                |
      | SpecimenImage | download               | Superuser, Administrator |
      | Confirmation  | read                   | Superuser, Administrator |
      | Confirmation  | create                 | Superuser                |
      | Confirmation  | update                 | Superuser                |
    And I have enough static data to create specimens
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Editing legacy specimen with no date should not throw collection date validation errors
    Given I have legacy specimen "NE1"
    And I am on the edit specimen page for "NE1"
    And I fill in "specimen_collection_date_day" with ""
    And I fill in "specimen_collection_date_month" with ""
    And I fill in "specimen_collection_date_year" with ""
    And I press "Update Specimen"
    Then I should see "The specimen was successfully updated."

  Scenario: Editing legacy specimen with year only should not throw validation errors
    Given I have legacy specimen "NE1"
    And I am on the edit specimen page for "NE1"
    And I fill in "specimen_collection_date_day" with ""
    And I fill in "specimen_collection_date_month" with ""
    And I fill in "specimen_collection_date_year" with "2012"
    And I press "Update Specimen"
    Then I should see "The specimen was successfully updated."

  Scenario: Editing legacy specimen with only day will throw validation error
    Given I have legacy specimen "NE2"
    And I am on the edit specimen page for "NE2"
    And I fill in "specimen_collection_date_day" with "21"
    And I fill in "specimen_collection_date_month" with ""
    And I fill in "specimen_collection_date_year" with ""
    And I press "Update Specimen"
    Then I should see "Enter a year for Collection date"

  Scenario: Editing legacy specimen with only month will throw validation error
    Given I have legacy specimen "NE3"
    And I am on the edit specimen page for "NE3"
    And I fill in "specimen_collection_date_day" with ""
    And I fill in "specimen_collection_date_month" with "10"
    And I fill in "specimen_collection_date_year" with ""
    And I press "Update Specimen"
    Then I should see "Enter a year for Collection date"

  Scenario: Editing legacy determinations with no dates should not throw determination validation errors
    Given I have legacy specimen "NE1"
    And "NE1" has a legacy determination with string "DET"
    When I am on the edit determination page for "NE1"
    And I fill in "determination_determination_date_day" with ""
    And I fill in "determination_determination_date_month" with ""
    And I fill in "determination_determination_date_year" with ""
    And I press "Continue"
    And I press "Save"
    Then I should see "Determination was successfully updated."

  Scenario: Editing legacy determinations with year should not throw validation errors
    Given I have legacy specimen "NE1"
    And "NE1" has a legacy determination with string "DET"
    When I am on the edit determination page for "NE1"
    And I fill in "determination_determination_date_day" with ""
    And I fill in "determination_determination_date_month" with ""
    And I fill in "determination_determination_date_year" with "2012"
    And I press "Continue"
    And I press "Save"
    Then I should see "Determination was successfully updated."

  Scenario: Editing legacy determinations with only month should throw validation error
    Given I have legacy specimen "NE1"
    And "NE1" has a legacy determination with string "DET"
    When I am on the edit determination page for "NE1"
    And I fill in "determination_determination_date_day" with ""
    And I fill in "determination_determination_date_month" with "12"
    And I fill in "determination_determination_date_year" with ""
    And I press "Continue"
    Then I should see "Enter a year for Determination date"

  Scenario: Editing legacy confirmations should not throw validation errors
    Given I have legacy specimen "NE1"
    And "NE1" has a legacy determination with string "DET"
    And "NE1" has a legacy confirmation
    When I am on the edit confirmation page for "NE1"
    And I fill in "confirmation_confirmation_date_day" with ""
    And I fill in "confirmation_confirmation_date_month" with ""
    And I fill in "confirmation_confirmation_date_year" with ""
    And I press "Update Confirmation"
    Then I should see "Confirmation was successfully updated."

  Scenario: Editing legacy people should not throw validation errors
