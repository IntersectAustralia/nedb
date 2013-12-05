Feature: Deaccession
  In order to track status of my specimens
  As a user
  I want to record deaccession
  
  Background:
    Given I have a specimen
    And I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity   | action              | profiles                          |
      | Specimen | request_deaccession | Superuser, Administrator          |
      | Specimen | approve_deaccession | Superuser                         |
      | Specimen | unflag_deaccession  | Superuser                         |
      | Specimen | view_deaccessioned  | Superuser                         |
      | Specimen | read                | Superuser, Administrator, Student |
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I have a user "raul@intersect.org.au" with profile "Administrator"
    And I have a user "diego@intersect.org.au" with profile "Student"
  
  Scenario: Request de-accession
    Given I am logged in as "georgina@intersect.org.au"
    And I am on the specimen page
    When I press "Flag for deaccession"
    Then I should see "The request for deaccession has been successful."
    And I should not see button "Flag for deaccession"
    And the specimen should have status "DeAccReq"

  Scenario: Superusers should receive an email when deaccession requested
    Given I am logged in as "georgina@intersect.org.au"
    And I am on the specimen page
    When I press "Flag for deaccession"
    Then "georgina@intersect.org.au" should receive an email
    When I open the email
    Then I should see "The following specimen has been flagged for deaccession:" in the email body      
    When I follow "Click here to view the specimen" in the email
    Then I should be on the specimen page
    And I should see button "Unflag deaccession"
    And I should see button "Confirm deaccession"

  Scenario: Unflag de-accesssion
    Given I am logged in as "georgina@intersect.org.au"
    And I am on the specimen page
    When I press "Flag for deaccession"
    And I press "Unflag deaccession"
    Then I should see "The deaccession has been unflagged."
    And I should see button "Flag for deaccession"
    And the specimen should have status ""

  Scenario: Confirm de-accesssion
    Given I am logged in as "georgina@intersect.org.au"
    And I am on the specimen page
    When I press "Flag for deaccession"
    And I press "Confirm deaccession"
    Then I should see "The deaccession has been approved."
    But I should not see button "Flag for deaccession"
    And I should see "Deaccessed: "
    And the specimen should have status "DeAcc"


  Scenario: Administrators can request but not approve or unflag de-accession
    Given I am logged in as "raul@intersect.org.au"
    And I am on the specimen page
    When I press "Flag for deaccession"
    Then I should see "The request for deaccession has been successful."
    And I should not see button "Flag for deaccession"
    And I should not see button "Unflag deaccession"
    And I should not see button "Confirm deaccession"
  
  Scenario: Students cannot flag for de-accession
    Given I am logged in as "diego@intersect.org.au"
    When I am on the specimen page
    Then I should not see button "Flag for deaccession"
    And I should not see button "Unflag deaccession"
    And I should not see button "Confirm deaccession"
  