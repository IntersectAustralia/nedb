Feature: Specimens created by unauthorised users are marked as needing review
  In order to keep an accurate record of specimens
  As a System Owner
  I want specimens created by student users to be marked as needing review
  
  Background:
    Given I have no specimens
    And I have people
        | initials |  last_name   |
        | G.R.     |  Adams       |
        | F.G.     |  Wells       |
        | H.C.     |  Smith       |
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
      | entity   | action                    | profiles                          |
      | Specimen | create_not_needing_review | Superuser, Administrator          |
      | Specimen | view_needing_review       | Superuser, Administrator          |
      | Specimen | mark_as_reviewed          | Superuser                         |
      | Specimen | create                    | Superuser, Administrator, Student |
      | Specimen | read                      | Superuser, Administrator, Student |
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I have a user "raul@intersect.org.au" with profile "Administrator"
    And I have a user "diego@intersect.org.au" with profile "Student"

  Scenario: Student user creates specimen
    Given I am logged in as "diego@intersect.org.au"
    When I create a new specimen
    Then the specimen needs review
    
  Scenario: Admin user creates specimen
    Given I am logged in as "raul@intersect.org.au"
    When I create a new specimen
    Then the specimen is marked as not needing review

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
      | Specimen   |
      | No determination |
      | No determination |
      
  Scenario: Student user cannot see the list of specimens needing review
    Given I am logged in as "diego@intersect.org.au"
    When I am on the admin page
    Then I should not see "Specimens Needing Review"
