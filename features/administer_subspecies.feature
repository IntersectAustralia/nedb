Feature: Administer Species
  In order to keep the system up to date
  As a user
  I want to manage the list of subspecies for a species

  Background:
    Given I have species
      | division | class_name | order_name | family | sub_family | tribe | genus   | name         | authority |
      | Div      | Cls        | Ord        | Fam    | SubFam     | Trb   | Banksia | integrifolia | auth      |
    And species "integrifolia" has subspecies
      | subspecies | authority   |
      | subsp1     | SubSp1-auth |
      | subsp2     | SubSp2-auth |
      | subsp3     | SubSp3-auth |
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Create subspecies
    Given I am on the species page for "integrifolia"
    And I follow "Create New Subspecies"
    And I fill in "Subspecies" with "NewSubSp"
    And I fill in "Authority" with "NewAuth"
    And I press "Create Subspecies"
    Then I should see "The subspecies was successfully created."
    And I should see "Species Details"
    Then I should see "subspecies_table" table with
      | Subspecies | Authority   |
      | newsubsp   | NewAuth     |
      | subsp1     | SubSp1-auth |
      | subsp2     | SubSp2-auth |
      | subsp3     | SubSp3-auth |

  Scenario: Cancel out of create
    Given I am on the species page for "integrifolia"
    And I follow "Create New Subspecies"
    When I follow "Cancel"
    Then I should be on the species page for "integrifolia"

  Scenario: Edit subspecies details
    Given I am on the species page for "integrifolia"
    And I follow "Edit" for subspecies "subsp1"
    And I fill in "Subspecies" with "NewSubSp"
    And I fill in "Authority" with "NewAuth"
    And I press "Update Subspecies"
    Then I should see "The subspecies was successfully updated."
    And I should see "subspecies_table" table with
      | Subspecies | Authority   |
      | newsubsp   | NewAuth     |
      | subsp2     | SubSp2-auth |
      | subsp3     | SubSp3-auth |

  Scenario: Cancel out of edit
    Given I am on the species page for "integrifolia"
    And I follow "Edit" for subspecies "subsp1"
    When I follow "Cancel"
    Then I should be on the species page for "integrifolia"

  Scenario: Delete a subspecies
    Given I am on the species page for "integrifolia"
    And I follow "Delete" for subspecies "subsp1"
    Then I should see "The subspecies was successfully deleted."
    And I should see "subspecies_table" table with
      | Subspecies | Authority   |
      | subsp2     | SubSp2-auth |
      | subsp3     | SubSp3-auth |
