Feature: Approve access requests
  In order to manage the system
  As an administrator
  I want to reject access requests
  
  Background:
    Given I have no users
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au"
    And "georgina@intersect.org.au" has profile "Superuser"
    And I have access requests
      | email                  | first_name | last_name        | title | other_initials | position | supervisor  | group_school_institution | address            | telephone  |
      | ryan@intersect.org.au  | Ryan       | Braganza         | Mr    | D              | TA       | Fred Jones  |                          |                    | 0411111111 |
      | diego@intersect.org.au | Diego      | Alonso de Marcos | Mr    | C              | RA       | Fred Bloggs | Intersect                | 309 Kent St Sydney | 08 8345678 |
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Reject an access request from the list page
    Given I am on the access requests page
    When I follow "Reject" for "diego@intersect.org.au"
    Then I should see "The access request for diego@intersect.org.au was rejected."
    And I should see "access_requests" table with
      | First name | Last name | Email                 | Telephone  | Group/School/Institution |
      | Ryan       | Braganza  | ryan@intersect.org.au | 0411111111 |                          |

  Scenario: Reject an access request as spam from the list page
    Given I am on the access requests page
    When I follow "Reject as Spam" for "diego@intersect.org.au"
    Then I should see "The access request for diego@intersect.org.au was rejected and this email address will be permanently blocked."
    And I should see "access_requests" table with
      | First name | Last name | Email                 | Telephone  | Group/School/Institution |
      | Ryan       | Braganza  | ryan@intersect.org.au | 0411111111 |                          |

  Scenario: Reject an access request from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "diego@intersect.org.au"
    And I follow exact link "Reject"
    Then I should see "The access request for diego@intersect.org.au was rejected."
    And I should see "access_requests" table with
      | First name | Last name | Email                 | Telephone  | Group/School/Institution |
      | Ryan       | Braganza  | ryan@intersect.org.au | 0411111111 |                          |

  Scenario: Reject an access request as spam from the view details page
    Given I am on the access requests page
    When I follow "View Details" for "diego@intersect.org.au"
    And I follow "Reject as Spam"
    Then I should see "The access request for diego@intersect.org.au was rejected and this email address will be permanently blocked."
    And I should see "access_requests" table with
      | First name | Last name | Email                 | Telephone  | Group/School/Institution |
      | Ryan       | Braganza  | ryan@intersect.org.au | 0411111111 |                          |

  Scenario: Rejected user should not be able to log in
    Given I am on the access requests page
    When I follow "Reject" for "diego@intersect.org.au"
    And I follow "Logout"
    And I am on the login page
    And I fill in "Email" with "diego@intersect.org.au"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Invalid email or password."
    And I should be on the login page

  Scenario: Rejected as spam user should not be able to log in
    Given I am on the access requests page
    When I follow "Reject as Spam" for "diego@intersect.org.au"
    And I follow "Logout"
    And I am on the login page
    And I fill in "Email" with "diego@intersect.org.au"
    And I fill in "Password" with "Pas$w0rd"
    And I press "Log in"
    Then I should see "Your account is not active."
    And I should be on the login page

  Scenario: Rejected user should be able to apply again
    Given I am on the access requests page
    When I follow "Reject" for "diego@intersect.org.au"
    And I follow "Logout"
    And I am on the request account page
    And I fill in the following:
      | Email                 | diego@intersect.org.au |
      | Password              | Pas$w0rd               |
      | Confirm password      | Pas$w0rd               |
      | First name            | Fred                   |
      | Last name             | Bloggs                 |
    And I press "Submit Request"
    Then I should see "Thanks for requesting an account. You will receive an email when your request has been approved."

  Scenario: Rejected as spam user should not be able to apply again
    Given I am on the access requests page
    When I follow "Reject as Spam" for "diego@intersect.org.au"
    And I follow "Logout"
    And I am on the request account page
    And I fill in the following:
      | Email                 | diego@intersect.org.au |
      | Password              | Pas$w0rd               |
      | Confirm password      | Pas$w0rd               |
      | First name            | Fred                   |
      | Last name             | Bloggs                 |
    Then I press "Submit Request"

