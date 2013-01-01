Feature: Administer Species
  In order to keep the system up to date
  As a user
  I want to manage the list of forms for a species

  Background:
    Given I have species
      | division | class_name | order_name | family | sub_family | tribe | genus   | name         | authority |
      | Div      | Cls        | Ord        | Fam    | SubFam     | Trb   | Banksia | integrifolia | auth      |
    And species "integrifolia" has forms
      | form | authority |
      | f1   | F1-auth   |
      | f2   | F2-auth   |
      | f3   | F3-auth   |
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Create form
    Given I am on the species page for "integrifolia"
    And I follow "Create New Form"
    And I fill in "Form" with "NewForm"
    And I fill in "Authority" with "NewAuth"
    And I press "Create Form"
    Then I should see "The form was successfully created."
    And I should see "Species Details"
    Then I should see "forms_table" table with
      | Form    | Authority |
      | f1      | F1-auth   |
      | f2      | F2-auth   |
      | f3      | F3-auth   |
      | newform | NewAuth   |

  Scenario: Cancel out of create
    Given I am on the species page for "integrifolia"
    And I follow "Create New Form"
    When I follow "Cancel"
    Then I should be on the species page for "integrifolia"

  Scenario: Edit form details
    Given I am on the species page for "integrifolia"
    And I follow "Edit" for form "f1"
    And I fill in "Form" with "NewForm"
    And I fill in "Authority" with "NewAuth"
    And I press "Update Form"
    Then I should see "The form was successfully updated."
    And I should see "forms_table" table with
      | Form    | Authority |
      | f2      | F2-auth   |
      | f3      | F3-auth   |
      | newform | NewAuth   |

  Scenario: Cancel out of edit
    Given I am on the species page for "integrifolia"
    And I follow "Edit" for form "f1"
    When I follow "Cancel"
    Then I should be on the species page for "integrifolia"

  Scenario: Delete a form
    Given I am on the species page for "integrifolia"
    And I follow "Delete" for form "f1"
    Then I should see "The form was successfully deleted."
    And I should see "forms_table" table with
      | Form | Authority |
      | f2   | F2-auth   |
      | f3   | F3-auth   |
