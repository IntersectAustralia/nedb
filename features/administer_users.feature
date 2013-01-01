Feature: Administer users
  In order to allow users to access the system
  As an administrator
  I want to administer users
  
  Background:
    Given I have no users
    And I have users
      | email                     | first_name | last_name | title | other_initials | position | supervisor  | group_school_institution | address            | telephone   |
      | georgina@intersect.org.au | Georgina   | Edwards   |       |                |          |             |                          |                    |             |
      | raul@intersect.org.au     | Raul       | Carrizo   | Mr    | F              | RA       | Fred Bloggs | Intersect                | 309 Kent St Sydney | 02 8345 678 |
    And I have access requests
      | email                  | first_name | last_name        |
      | ryan@intersect.org.au  | Ryan       | Braganza         |
      | diego@intersect.org.au | Diego      | Alonso de Marcos |
    And I have the usual profiles and permissions
    And I am logged in as "georgina@intersect.org.au"
    And "georgina@intersect.org.au" has profile "Superuser"

  Scenario: View a list of users
    Given I am on the home page
    And "raul@intersect.org.au" is deactivated
    When I follow "Admin"
    And I follow "List Approved Users"
    Then I should see "users" table with
      | First name | Last name | Email                     | Profile   | Status      | Telephone   | Group/School/Institution |
      | Georgina   | Edwards   | georgina@intersect.org.au | Superuser | Active      |             |                          |
      | Raul       | Carrizo   | raul@intersect.org.au     |           | Deactivated | 02 8345 678 | Intersect                |

  Scenario: View user details
    Given "raul@intersect.org.au" has profile "Student"
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    Then I should see field "Email" with value "raul@intersect.org.au"
    And I should see field "Title" with value "Mr"
    And I should see field "First name" with value "Raul"
    And I should see field "Last name" with value "Carrizo"
    And I should see field "Other Initials" with value "F"
    And I should see field "Position" with value "RA"
    And I should see field "Supervisor" with value "Fred Bloggs"
    And I should see field "Group, School, Institution" with value "Intersect"
    And I should see field "Address" with value "309 Kent St Sydney"
    And I should see field "Telephone" with value "02 8345 678"
    #Then I should see field "Date Requested Access" with value "2010-10-18 21:15:34 UTC"
    And I should see field "Profile" with value "Student"
    And I should see field "Status" with value "Active"
    
  Scenario: Go back from user details
    Given I am on the list users page
    When I follow "View Details" for "georgina@intersect.org.au"
    And I follow "Back" within the main content
    Then I should be on the list users page

  Scenario: Edit profile
    Given "raul@intersect.org.au" has profile "Student"
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Edit Profile"
    And I select "Superuser" from "Profile"
    And I press "Save"
    Then I should be on the user details page for raul@intersect.org.au
    And I should see "The profile for raul@intersect.org.au was successfully updated."
    And I should see field "Profile" with value "Superuser"

  Scenario: Edit profile from list page
    Given "raul@intersect.org.au" has profile "Student"
    And I am on the list users page
    When I follow "Edit Profile" for "raul@intersect.org.au"
    And I select "Superuser" from "Profile"
    And I press "Save"
    Then I should be on the user details page for raul@intersect.org.au
    And I should see "The profile for raul@intersect.org.au was successfully updated."
    And I should see field "Profile" with value "Superuser"

  Scenario: Cancel out of editing profiles
    Given "raul@intersect.org.au" has profile "Student"
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Edit Profile"
    And I select "Superuser" from "Profile"
    And I follow "Cancel"
    Then I should be on the user details page for raul@intersect.org.au
    And I should see field "Profile" with value "Student"
      
  Scenario: Profile should be mandatory when editing profile
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Edit Profile"
    And I select "Please select" from "Profile"
    And I press "Save"
    Then I should see "Please select a profile for the user."

  Scenario: Deactivate active user
    Given I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Deactivate"
    Then I should see "The user has been deactivated"
    And I should see "Activate"

  Scenario: Activate deactivated user
    Given "raul@intersect.org.au" is deactivated
    And I am on the list users page
    When I follow "View Details" for "raul@intersect.org.au"
    And I follow "Activate"
    Then I should see "The user has been activated"
    And I should see "Deactivate"
