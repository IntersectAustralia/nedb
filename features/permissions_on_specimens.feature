Feature: Permissions to manage people
  In order to keep the system secure
  As the system owner
  I want to restrict access to the people management functionality

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
    # REVIEWME
    # Given I have the usual profiles and permissions
    And I have enough static data to create specimens
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"
    And I have a user "student@intersect.org.au" with profile "Student"
    And I have specimen "specimen 1" with status ""
    And "specimen 1" has a determination with string "BCD"
    And "specimen 1" has a confirmation
    And "specimen 1" has an item
    And "specimen 1" has an image
    And I have specimen "specimen 2" with status ""
    And "specimen 2" has a determination with string "DEF"

  Scenario: Student can't do anything on specimens
    Given I am logged in as "student@intersect.org.au"
    Then I should get the following security outcomes
      | page | outcome | message |
      | the new specimen page                            | error   | You do not have permissions to perform this action. |
      | the specimen page for "specimen 1"               | error   | You do not have permissions to view this specimen.  |
      | the edit specimen page for "specimen 1"          | error   | You do not have permissions to perform this action. |
      | the edit replicates page for "specimen 1"        | error   | You do not have permissions to perform this action. |
      | the view determination page for "specimen 1"     | error   | You do not have permissions to view this specimen.  |
      | the create determination page for "specimen 1"   | error   | You do not have permissions to view this specimen.  |
      | the edit determination page for "specimen 1"     | error   | You do not have permissions to view this specimen.  |
      | the create confirmation page for "specimen 1"    | error   | You do not have permissions to view this specimen.  |
      | the edit confirmation page for "specimen 1"      | error   | You do not have permissions to view this specimen.  |
      | the specimens needing review page                | error   | You do not have permissions to perform this action. |
      | the view specimen image page for "specimen 1"    | error   | You do not have permissions to view this specimen.  |
      | the new specimen image page for "specimen 1"     | error   | You do not have permissions to view this specimen.  |
    # REVIEWME
      # | the new specimen page                          | ok    |                                                     |
      # | the specimen page for "specimen 1"             | ok    |                                                     |
      # | the edit specimen page for "specimen 1"        | ok    |                                                     |
      # | the edit replicates page for "specimen 1"      | ok    |                                                     |
      # | the view determination page for "specimen 1"   | ok    |                                                     |
      # | the create determination page for "specimen 1" | ok    |                                                     |
      # | the edit determination page for "specimen 1"   | ok    |                                                     |
      # | the create confirmation page for "specimen 1"  | ok    |                                                     |
      # | the edit confirmation page for "specimen 1"    | ok    |                                                     |
      # | the specimens needing review page              | error | You do not have permissions to perform this action. |
      # | the view specimen image page for "specimen 1"  | ok    |                                                     |
      # | the new specimen image page for "specimen 1"   | ok    |                                                     |

  Scenario: Admin can view but not edit specimens
    Given I am logged in as "admin@intersect.org.au"
    Then I should get the following security outcomes
      | page | outcome | message |
      | the new specimen page                             | error   | You do not have permissions to perform this action. |
      | the specimen page for "specimen 1"                | ok      |                                                     |
      | the edit specimen page for "specimen 1"           | error   | You do not have permissions to perform this action. |
      | the edit replicates page for "specimen 1"         | error   | You do not have permissions to perform this action. |
      | the view determination page for "specimen 1"      | ok      |                                                     |
      | the create determination page for "specimen 1"    | error   | You do not have permissions to perform this action. |
      | the edit determination page for "specimen 1"      | error   | You do not have permissions to perform this action. |
      | the create confirmation page for "specimen 1"     | error   | You do not have permissions to perform this action. |
      | the edit confirmation page for "specimen 1"       | error   | You do not have permissions to perform this action. |
      | the specimens needing review page                 | ok      |                                                     |
      | the view specimen image page for "specimen 1"     | ok      |                                                     |
      | the new specimen image page for "specimen 1"      | error   | You do not have permissions to perform this action. |
    # REVIEWME
      # | the new specimen page                          | ok |  |
      # | the specimen page for "specimen 1"             | ok |  |
      # | the edit specimen page for "specimen 1"        | ok |  |
      # | the edit replicates page for "specimen 1"      | ok |  |
      # | the view determination page for "specimen 1"   | ok |  |
      # | the create determination page for "specimen 1" | ok |  |
      # | the edit determination page for "specimen 1"   | ok |  |
      # | the create confirmation page for "specimen 1"  | ok |  |
      # | the edit confirmation page for "specimen 1"    | ok |  |
      # | the specimens needing review page              | ok |  |
      # | the view specimen image page for "specimen 1"  | ok |  |
      # | the new specimen image page for "specimen 1"   | ok |  |

  Scenario: Superuser can do everything
    Given I am logged in as "super@intersect.org.au"
    Then I should get the following security outcomes
      | page                                           | outcome | message |
      | the new specimen page                          | ok      |         |
      | the specimen page for "specimen 1"             | ok      |         |
      | the edit specimen page for "specimen 1"        | ok      |         |
      | the edit replicates page for "specimen 1"      | ok      |         |
      | the view determination page for "specimen 1"   | ok      |         |
      | the create determination page for "specimen 1" | ok      |         |
      | the edit determination page for "specimen 1"   | ok      |         |
      | the create confirmation page for "specimen 1"  | ok      |         |
      | the edit confirmation page for "specimen 1"    | ok      |         |
      | the specimens needing review page              | ok      |         |
      | the view specimen image page for "specimen 1"  | ok      |         |
      | the new specimen image page for "specimen 1"   | ok      |         |


  Scenario: Admin can view but not edit so should not see edit links
    Given I am logged in as "admin@intersect.org.au"
    When I am on the specimen page for "specimen 1"
    Then I should not see link "Edit Specimen Details"
    And I should not see link "Edit Replicates"
    And I should not see link "Add Determination"
    And I should not see link "Edit determination"
    And I should not see link "Edit confirmation"
    And I should not see button "Add" within the items area
    And I should not see link "Delete" inside the items area
    When I am on the specimen page for "specimen 2"
    Then I should not see link "Add confirmation"
    And I should not see link "Add Image"
    When I am on the view determination page for "specimen 1"
    Then I should not see link "Edit"
    When I am on the view specimen image page for "specimen 1"
    Then I should not see link "Delete Image"
    Then I should see link "Download Image"
    # REVIEW ME
    # Given I am logged in as "admin@intersect.org.au"
    # When I am on the specimen page for "specimen 1"
    # Then I should see link "Edit Specimen Details"
    # And I should see link "Edit Replicates"
    # And I should see link "Add Determination"
    # And I should see link "Edit determination"
    # And I should see link "Edit confirmation"
    # And I should see button "Add" within the items area
    # And I should see link "Delete" inside the items area
    # When I am on the specimen page for "specimen 2"
    # Then I should see link "Add confirmation"
    # And I should see link "Add Image"
    # When I am on the view determination page for "specimen 1"
    # Then I should see link "Edit"
    # When I am on the view specimen image page for "specimen 1"
    # Then I should not see link "Delete Image"
    # Then I should see link "Download Image"

  Scenario: Superuser can do anything so should see edit links
    Given I am logged in as "super@intersect.org.au"
    When I am on the specimen page for "specimen 1"
    Then I should see link "Edit Specimen Details"
    And I should see link "Edit Replicates"
    And I should see link "Add Determination"
    And I should see link "Edit determination"
    And I should see link "Edit confirmation"
    And I should see button "Add" within the items area
    And I should see link "Delete" inside the items area
    When I am on the specimen page for "specimen 2"
    Then I should see link "Add confirmation"
    And I should see link "Add Image"
    When I am on the view specimen image page for "specimen 1"
    Then I should see link "Delete Image"
    Then I should see link "Download Image"

    When I am on the view determination page for "specimen 1"
    Then I should see link "Edit"

  Scenario: Superuser should see specimens needing review link on admin page
    Given I am logged in as "super@intersect.org.au"
    When I am on the admin page
    Then I should see link "Specimens Needing Review"

  Scenario: Student should not see specimens needing review link on admin page
    Given I am logged in as "student@intersect.org.au"
    When I am on the admin page
    Then I should not see link "Specimens Needing Review"
