Feature: Administer Species
  In order to keep the system up to date
  As a user
  I want to manage the list of species

  Background:
    Given I have species
      | division | class_name | order_name | family | sub_family | tribe | genus   | name         | authority |
      | Div      | Cls        | Ord        | Fam    | Subfam     | Trb   | Banksia | integrifolia | auth      |
      | Div      | Cls        | Ord        | Fam    | Subfam     | Trb   | Banksia | victoriae    | auth      |
      | Div      | Cls        | Ord        | Fam    | Subfam     | Trb   | Banksia | acuminata    | auth      |
    And species "integrifolia" has varieties
      | variety | authority |
      | v1      | V1-auth   |
      | v2      | V2-auth   |
      | v3      | V3-auth   |
    And species "integrifolia" has subspecies
      | subspecies | authority   |
      | subsp1     | SubSp1-auth |
      | subsp2     | SubSp2-auth |
      | subsp3     | SubSp3-auth |
    And species "integrifolia" has forms
      | form | authority |
      | f1   | F1-auth   |
      | f2   | F2-auth   |
      | f3   | F3-auth   |
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the homepage
    And I follow "Admin"
    And I follow "Manage Species"

  Scenario: Create species
    When I follow "Create New Species"
    Then I should see "New Species"
    And I fill in "Division" with "Div"
    And I fill in "Class" with "Cls"
    And I fill in "Order" with "Ord"
    And I fill in "Family" with "Fam"
    And I fill in "Subfamily" with "Subfam"
    And I fill in "Tribe" with "Trb"
    And I fill in "Genus" with "Banksia"
    And I fill in "Species" with "incana"
    And I fill in "Authority" with "auth"
    And I press "Create Species"
    Then I should see "Species was successfully created."
    And I should see "Species Details"
    And I should see field "Division" with value "Div"
    And I should see field "Class" with value "Cls"
    And I should see field "Order" with value "Ord"
    And I should see field "Family" with value "Fam"
    And I should see field "Subfamily" with value "Subfam"
    And I should see field "Tribe" with value "Trb"
    And I should see field "Genus" with value "Banksia"
    And I should see field "Species" with value "incana"
    And I should see field "Authority" with value "auth"

  Scenario: Cancel out of create
    When I follow "Create New Species"
    And I follow "Cancel"
    Then I should be on the list species page

  Scenario: List species
    When I do a species search for "Div"
    Then I should see "species_table" table with
      | Division | Class | Order | Family | Subfamily | Tribe | Genus   | Species      | Authority |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | acuminata    | auth      |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | integrifolia | auth      |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | victoriae    | auth      |

  Scenario: View species
    When I do a species search for "Div"
    And I follow "View" for species "integrifolia"
    Then I should see "Species Details"
    And I should see field "Division" with value "Div"
    And I should see field "Class" with value "Cls"
    And I should see field "Order" with value "Ord"
    And I should see field "Family" with value "Fam"
    And I should see field "Subfamily" with value "Subfam"
    And I should see field "Tribe" with value "Trb"
    And I should see field "Genus" with value "Banksia"
    And I should see field "Species" with value "integrifolia"
    And I should see field "Authority" with value "auth"

  Scenario: View species and use back link
    When I do a species search for "Div"
    And I follow "View" for species "integrifolia"
    Then I should see "Species Details"
    When I follow "Back" within the main content
    Then I should be on the list species page

  Scenario: Edit species details
    When I do a species search for "Div"
    And I follow "Edit" for species "integrifolia"
    Then I should see "Edit Species"
    And I fill in "Division" with "Div2"
    And I fill in "Class" with "Cls2"
    And I fill in "Order" with "Ord2"
    And I fill in "Family" with "Fam2"
    And I fill in "Subfamily" with "SubFam2"
    And I fill in "Tribe" with "Trb2"
    And I fill in "Genus" with "Banksia2"
    And I fill in "Species" with "integrifolia2"
    And I fill in "Authority" with "auth2"
    And I press "Update Species"
    Then I should see "Species was successfully updated."
    And I should see "Species Details"
    And I should see field "Division" with value "Div2"
    And I should see field "Class" with value "Cls2"
    And I should see field "Order" with value "Ord2"
    And I should see field "Family" with value "Fam2"
    And I should see field "Subfamily" with value "Subfam2"
    And I should see field "Tribe" with value "Trb2"
    And I should see field "Genus" with value "Banksia2"
    And I should see field "Species" with value "integrifolia2"
    And I should see field "Authority" with value "auth2"

  Scenario: Cancel out of edit
    When I do a species search for "Div"
    And I follow "Edit" for species "integrifolia"
    And I follow "Cancel"
    Then I should see "Species Details"

  Scenario: View species should include varieties, forms and subspecies
    When I do a species search for "Div"
    And I follow "View" for species "integrifolia"
    Then I should see "Species Details"
    Then I should see "subspecies_table" table with
      | Subspecies | Authority   |
      | subsp1     | SubSp1-auth |
      | subsp2     | SubSp2-auth |
      | subsp3     | SubSp3-auth |
    Then I should see "varieties_table" table with
      | Variety | Authority |
      | v1      | V1-auth   |
      | v2      | V2-auth   |
      | v3      | V3-auth   |
    Then I should see "forms_table" table with
      | Form | Authority |
      | f1   | F1-auth   |
      | f2   | F2-auth   |
      | f3   | F3-auth   |

  Scenario: Search for species
    When I do a species search for "In"
    Then I should see "species_table" table with
      | Division | Class | Order | Family | Subfamily | Tribe | Genus   | Species      | Authority |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | acuminata    | auth      |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | integrifolia | auth      |

  Scenario: Go back to search results after viewing
    When I do a species search for "In"
    And I follow "View" for species "integrifolia"
    And I follow "Back" within the main content
    Then I should see "species_table" table with
      | Division | Class | Order | Family | Subfamily | Tribe | Genus   | Species      | Authority |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | acuminata    | auth      |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | integrifolia | auth      |

  Scenario: Delete species
    When I do a species search for "Div"
    When I follow "Delete" for species "integrifolia"
    Then I should see "species_table" table with
      | Division | Class | Order | Family | Subfamily | Tribe | Genus   | Species      | Authority |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | acuminata    | auth      |
      | Div      | Cls   | Ord   | Fam    | Subfam    | Trb   | Banksia | victoriae    | auth      |
    And I should have no subspecies
    And I should have no varieties
    And I should have no forms

