Feature: Manage Replicates
  In order to track the replicates for a specimen
  As a user
  I want to add, edit and delete replicates
  
  Background:
    Given I have a specimen
    And I have herbaria
      | code | name                     |
      | NSW  | NSW Botanical Gardens    |
      | WOLL | University of Wollongong |
      | SCU  | DNA Bank                 |
      | UNC  | University of Newcastle  |
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
  
  Scenario: Add Replicates
    Given I am on the specimen page
    When I follow "Edit Replicates"
    And I check "WOLL - University of Wollongong"
    And I check "UNC - University of Newcastle"
    And I press "Update Specimen"
    Then I should see "The replicates were successfully updated."
    And I should only see replicates
        | code | name                     |
        | WOLL | University of Wollongong |
        | UNC  | University of Newcastle  |

  Scenario: Edit Replicates
    Given the specimen has replicates
        | code |
        | WOLL |
        | UNC  |
    And I am on the specimen page
    When I follow "Edit Replicates"
    And I uncheck "WOLL - University of Wollongong"
    And I check "NSW - NSW Botanical Gardens"
    And I press "Update Specimen"
    Then I should see "The replicates were successfully updated."
    And I should only see replicates
        | code | name                    |
        | NSW  | NSW Botanical Gardens   |
        | UNC  | University of Newcastle |

  Scenario: Remove All Replicates
    Given the specimen has replicates
        | code |
        | WOLL |
        | UNC  |
    And I am on the specimen page
    When I follow "Edit Replicates"
    And I uncheck "WOLL - University of Wollongong"
    And I uncheck "UNC - University of Newcastle"
    And I press "Update Specimen"
    Then I should see "The replicates were successfully updated."
    And I should see no replicates

