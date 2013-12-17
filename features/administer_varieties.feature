Feature: Administer Species
  In order to keep the system up to date
  As a user
  I want to manage the list of varieties for a species

  Background:
    Given I have species
      | division | class_name | order_name | family | sub_family | tribe | genus   | name         | authority |
      | Div      | Cls        | Ord        | Fam    | SubFam     | Trb   | Banksia | integrifolia | auth      |
    And species "integrifolia" has varieties
      | variety | authority |
      | v1      | V1-auth   |
      | v2      | V2-auth   |
      | v3      | V3-auth   |
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Create variety
    Given I am on the species page for "integrifolia"
    And I follow "Create New Variety"
    And I fill in "Variety" with "NewVar"
    And I fill in "Authority" with "NewAuth"
    And I press "Create Variety"
    Then I should see "The variety was successfully created."
    And I should see "Species Details"
    Then I should see "varieties_table" table with
      | Variety | Authority |
      | newvar  | NewAuth   |
      | v1      | V1-auth   |
      | v2      | V2-auth   |
      | v3      | V3-auth   |

  Scenario Outline: Create variety with validation errors
    Given I am on the species page for "integrifolia"
    And I follow "Create New Variety"
    And I fill in "<field>" with "<value>"
    And I press "Create Variety"
    Then I should see /\d error(s)? need to be corrected before this record can be saved\./
    And the "<field>" field should have the error "<error>"

  Examples:
    | field      | value                                                                                                                                                                                                                                                           | error                                   |
    | Authority | ABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCD | is too long (maximum is 255 characters) |
    | Authority  |                                                                                                                                                                                                                                                                 | can't be blank                          |
    | Variety    | ABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCD | is too long (maximum is 255 characters) |
    | Variety    |                                                                                                                                                                                                                                                                 | can't be blank                          |

  Scenario: Cancel out of create
    Given I am on the species page for "integrifolia"
    And I follow "Create New Variety"
    When I follow "Cancel"
    Then I should be on the species page for "integrifolia"

  Scenario: Edit variety details
    Given I am on the species page for "integrifolia"
    And I follow "Edit" for variety "v1"
    And I fill in "Variety" with "NewVar"
    And I fill in "Authority" with "NewAuth"
    And I press "Update Variety"
    Then I should see "The variety was successfully updated."
    And I should see "varieties_table" table with
      | Variety | Authority |
      | newvar  | NewAuth   |
      | v2      | V2-auth   |
      | v3      | V3-auth   |

  Scenario Outline: Edit a variety with validation errors
    Given I am on the species page for "integrifolia"
    And I follow "Edit" for variety "v1"
    And I fill in "<field>" with "<value>"
    And I press "Update Variety"
    Then I should see /\d error(s)? need to be corrected before this record can be saved\./
    And the "<field>" field should have the error "<error>"

  Examples:
    | field      | value                                                                                                                                                                                                                                                           | error                                   |
    | Authority | ABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCD | is too long (maximum is 255 characters) |
    | Authority  |                                                                                                                                                                                                                                                                 | can't be blank                          |
    | Variety    | ABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCDEFGHIJKLMNOPQRSTUABCD | is too long (maximum is 255 characters) |
    | Variety    |                                                                                                                                                                                                                                                                 | can't be blank                          |

  Scenario: Cancel out of edit
    Given I am on the species page for "integrifolia"
    And I follow "Edit" for variety "v1"
    When I follow "Cancel"
    Then I should be on the species page for "integrifolia"

  Scenario: Delete a variety
    Given I am on the species page for "integrifolia"
    And I follow "Delete" for variety "v1"
    Then I should see "The variety was successfully deleted."
    And I should see "varieties_table" table with
      | Variety | Authority |
      | v2      | V2-auth   |
      | v3      | V3-auth   |
