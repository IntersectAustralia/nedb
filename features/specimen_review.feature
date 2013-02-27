Feature: Specimens created by unauthorised users are marked as needing review
  In order to keep an accurate record of specimens
  As a System Owner
  I want specimens created by student users to be marked as needing review

  Background:
    Given I have no specimens
    And I have people
      | initials | last_name |
      | G.R.     | Adams     |
      | F.G.     | Wells     |
      | H.C.     | Smith     |
    And I have countries
      | name         |
      | Algeria      |
      | Australia    |
      | Switzerland  |
      | Peru         |
      | South Africa |
    And I have states
      | name            | country      |
      | New South Wales | Australia    |
      | Victoria        | Australia    |
      | Free State      | South Africa |
      | Western Cape    | South Africa |
    And I have botanical divisions
      | name | state           |
      | BD1  | New South Wales |
      | BD2  | New South Wales |
    And I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity        | action                    | profiles                          |
      | Specimen      | create_not_needing_review | Superuser, Administrator          |
      | Specimen      | view_needing_review       | Superuser, Administrator          |
      | Specimen      | mark_as_reviewed          | Superuser                         |
      | Specimen      | read                      | Superuser, Administrator, Student |
      | Specimen      | update                    | Superuser, Administrator, Student |
      | Specimen      | update_replicates         | Superuser, Administrator, Student |
      | Specimen      | create                    | Superuser, Administrator, Student |
      | Specimen      | update_specimen_images    | Superuser, Administrator, Student |
      | Specimen      | add_item                  | Superuser, Administrator, Student |
      | Item          | destroy                   | Superuser, Administrator, Student |
      | SpecimenImage | read                      | Superuser, Administrator, Student |
      | SpecimenImage | create                    | Superuser, Administrator, Student |
      | SpecimenImage | update                    | Superuser, Administrator, Student |
      | SpecimenImage | download                  | Superuser, Administrator, Student |
      | SpecimenImage | display_image             | Superuser, Administrator, Student |
      | SpecimenImage | destroy                   | Superuser                         |
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I have a user "raul@intersect.org.au" with profile "Administrator"
    And I have a user "diego@intersect.org.au" with profile "Student"

  Scenario Outline: Create specimen
    Given I am logged in as "<email>"
    When I create a new specimen
    Then the specimen <outcome>

  Examples:
    | email                  | outcome                         |
    | diego@intersect.org.au | needs review                    |
    | raul@intersect.org.au  | is marked as not needing review |

  Scenario Outline: Update specimen
    Given I am logged in as "<email>"
    And I have a specimen
    When I am on the specimen page
    Then the specimen is marked as not needing review
    And I follow "Edit Specimen Details"
    And I press "Update Specimen"
    And the specimen <outcome>

  Examples:
    | email                  | outcome                         |
    | diego@intersect.org.au | needs review                    |
    | raul@intersect.org.au  | is marked as not needing review |

  Scenario Outline: Add item to specimen
    Given I am logged in as "<email>"
    And I have item types Test
    And I have a specimen
    When I am on the specimen page
    Then the specimen is marked as not needing review
    And I press "Add"
    And I should see "The item was successfully added."
    And the specimen <outcome>

  Examples:
    | email                  | outcome                         |
    | diego@intersect.org.au | needs review                    |
    | raul@intersect.org.au  | is marked as not needing review |

  Scenario Outline: Remove item from specimen
    Given I am logged in as "<email>"
    And I have item types Test
    And I have specimens
      | tag      |
      | specimen |
    And "specimen" has an item
    When I am on the specimen page for "specimen"
    Then the specimen is marked as not needing review
    And I follow "Delete"
    And I should see "The item was successfully deleted."
    And the specimen <outcome>

  Examples:
    | email                  | outcome                         |
    | diego@intersect.org.au | needs review                    |
    | raul@intersect.org.au  | is marked as not needing review |

  Scenario Outline: Add image to specimen
    Given I am logged in as "<email>"
    And I have item types Test
    And I have a specimen
    When I am on the specimen page
    Then the specimen is marked as not needing review
    When I follow "Add Image"
    Then I should see "Upload New Image"
    When I attach an image file
    And I fill in "Description" with "desc1"
    And I press "Upload"
    Then I should see "The specimen image was uploaded successfully."
    And the specimen <outcome>

  Examples:
    | email                  | outcome                         |
    | diego@intersect.org.au | needs review                    |
    | raul@intersect.org.au  | is marked as not needing review |

  Scenario Outline: Edit specimen image
    Given I am logged in as "<email>"
    And I have item types Test
    And I have specimens
      | tag      |
      | specimen |
    When I am on the specimen page for "specimen"
    Then the specimen is marked as not needing review
    And "specimen" has an image
    And I am on the view specimen image page for "specimen"
    And I follow "Edit Description"
    And I fill in "Description" with "test description"
    And I press "Save"
    And I should see "The specimen image description was successfully updated."
    When I am on the specimen page for "specimen"
    And the specimen <outcome>

  Examples:
    | email                  | outcome                         |
    | diego@intersect.org.au | needs review                    |
    | raul@intersect.org.au  | is marked as not needing review |

  Scenario Outline: Edit specimen replicates
    Given I am logged in as "<email>"
    And I have a specimen
    When I am on the specimen page
    Then the specimen is marked as not needing review
    And I follow "Edit Replicates"
    And I press "Update Specimen"
    And I should see "The replicates were successfully updated."
    And the specimen <outcome>

  Examples:
    | email                  | outcome                         |
    | diego@intersect.org.au | needs review                    |
    | raul@intersect.org.au  | is marked as not needing review |

  Scenario: Superuser user mark specimen as reviewed
    Given I have a specimen that needs review
    And I am logged in as "georgina@intersect.org.au"
    When I am on the specimen page
    Then I should see button "Mark as Reviewed"

  Scenario: Student user cannot mark specimen as reviewed
    Given I have a specimen that needs review
    And I am logged in as "diego@intersect.org.au"
    When I am on the specimen page
    Then I should not see button "Mark as Reviewed"

  Scenario: Superuser user gets a list of specimens needing review
    Given I am logged in as "georgina@intersect.org.au"
    And I have a specimen that needs review
    And I have a specimen that needs review
    When I follow "Admin"
    And I follow "Specimens Needing Review"
    Then I should see "search_results_table" table with
      | Specimen         |
      | No determination |
      | No determination |

  Scenario: Student user cannot see the list of specimens needing review
    Given I am logged in as "diego@intersect.org.au"
    When I am on the admin page
    Then I should not see "Specimens Needing Review"
