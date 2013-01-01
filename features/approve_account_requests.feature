Feature: Approve access requests
  In order to allow users to access the system
  As an administrator
  I want to approve access requests
  
  Background:
    Given I have no users
    Given I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity | action               | profiles                 |
      | User   | read                 | Superuser, Administrator |
      | User   | view_access_requests | Superuser, Administrator |
      | User   | reject               | Superuser                |
      | User   | approve              | Superuser                |
    And I have a user "georgina@intersect.org.au"
    And "georgina@intersect.org.au" has profile "Superuser"
    And I have access requests
      | email                  | first_name | last_name        | title | other_initials | position | supervisor  | group_school_institution | address            | telephone  |
      | ryan@intersect.org.au  | Ryan       | Braganza         | Mr    | D              | TA       | Fred Jones  |                          |                    | 0411111111 |
      | diego@intersect.org.au | Diego      | Alonso de Marcos | Mr    | C              | RA       | Fred Bloggs | Intersect                | 309 Kent St Sydney | 08 8345678 |
    And I am logged in as "georgina@intersect.org.au"

  Scenario: View a list of access requests
    Given I am on the home page
    When I follow "Admin"
    And I follow "View Access Requests"
    Then I should see "access_requests" table with
      | First name | Last name        | Email                  | Telephone  | Group/School/Institution |
      | Diego      | Alonso de Marcos | diego@intersect.org.au | 08 8345678 | Intersect                |
      | Ryan       | Braganza         | ryan@intersect.org.au  | 0411111111 |                          |
      
  Scenario: Approve an access request from the list page
    Given I am on the access requests page
    When I follow "Approve" for "diego@intersect.org.au"
    And I select "Superuser" from "Profile"
    And I press "Approve"
    Then I should see "The access request for diego@intersect.org.au was approved."
    And I should see "access_requests" table with
      | First name | Last name | Email                 | Telephone  | Group/School/Institution |
      | Ryan       | Braganza  | ryan@intersect.org.au | 0411111111 |                          |

  Scenario: Cancel out of approving an access request from the list page
    Given I am on the access requests page
    When I follow "Approve" for "diego@intersect.org.au"
    And I select "Superuser" from "Profile"
    And I follow "Cancel"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      | First name | Last name        | Email                  | Telephone  | Group/School/Institution |
      | Diego      | Alonso de Marcos | diego@intersect.org.au | 08 8345678 | Intersect                |
      | Ryan       | Braganza         | ryan@intersect.org.au  | 0411111111 |                          |
  
  Scenario: View details of an access request
    Given I am on the access requests page
    When I follow "View Details" for "diego@intersect.org.au"
    Then I should see "diego@intersect.org.au"
    Then I should see field "Email" with value "diego@intersect.org.au"
    Then I should see field "Title" with value "Mr"
    Then I should see field "First name" with value "Diego"
    Then I should see field "Last name" with value "Alonso de Marcos"
    Then I should see field "Other Initials" with value "C"
    Then I should see field "Position" with value "RA"
    Then I should see field "Supervisor" with value "Fred Bloggs"
    Then I should see field "Group, School, Institution" with value "Intersect"
    Then I should see field "Address" with value "309 Kent St Sydney"
    Then I should see field "Telephone" with value "08 8345678"
    #Then I should see field "Date Requested Access" with value "2010-10-18 21:15:34 UTC"
    Then I should see field "Profile" with value ""
    Then I should see field "Status" with value "Pending Approval"

  Scenario: Approve an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "diego@intersect.org.au"
    And I follow "Approve"
    And I select "Superuser" from "Profile"
    And I press "Approve"
    Then I should see "The access request for diego@intersect.org.au was approved."
    And I should see "access_requests" table with
      | First name | Last name | Email                 | Telephone  | Group/School/Institution |
      | Ryan       | Braganza  | ryan@intersect.org.au | 0411111111 |                          |

  Scenario: Cancel out of approving an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "diego@intersect.org.au"
    And I follow "Approve"
    And I select "Superuser" from "Profile"
    And I follow "Cancel"
    Then I should be on the access requests page
    And I should see "access_requests" table with
      | First name | Last name        | Email                  | Telephone  | Group/School/Institution |
      | Diego      | Alonso de Marcos | diego@intersect.org.au | 08 8345678 | Intersect                |
      | Ryan       | Braganza         | ryan@intersect.org.au  | 0411111111 |                          |

  Scenario: Go back to the access requests page from the view details page without doing anything
    Given I am on the access requests page
    And I follow "View Details" for "diego@intersect.org.au"
    When I follow "Back" within the main content
    Then I should be on the access requests page
    And I should see "access_requests" table with
      | First name | Last name        | Email                  | Telephone  | Group/School/Institution |
      | Diego      | Alonso de Marcos | diego@intersect.org.au | 08 8345678 | Intersect                |
      | Ryan       | Braganza         | ryan@intersect.org.au  | 0411111111 |                          |
  
  Scenario: Profile should be mandatory when approving an access request
    Given I am on the access requests page
    When I follow "Approve" for "diego@intersect.org.au"
    And I press "Approve"
    Then I should see "Please select a profile for the user."

  Scenario: Approved user should be able to log in
    Given I am on the access requests page
    When I follow "Approve" for "diego@intersect.org.au"
    And I select "Superuser" from "Profile"
    And I press "Approve"
    And I follow "Logout"
    Then I should be able to log in with "diego@intersect.org.au" and "Pas$w0rd"

  Scenario: Approved user profiles should be correctly saved
    Given I am on the access requests page
    And I follow "Approve" for "diego@intersect.org.au"
    And I select "Superuser" from "Profile"
    And I press "Approve"
    And I am on the list users page
    When I follow "View Details" for "diego@intersect.org.au"
    And I should see field "Profile" with value "Superuser"
