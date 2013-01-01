Feature: Permissions to manage users
  In order to keep the system secure
  As the system owner
  I want to restrict access to the user management functionality

  Background:
    Given I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity | action               | profiles                 |
      | User   | read                 | Superuser, Administrator |
      | User   | update_profile       | Superuser                |
      | User   | activate_deactivate  | Superuser                |
      | User   | view_access_requests | Superuser, Administrator |
      | User   | reject               | Superuser                |
      | User   | approve              | Superuser                |
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"
    And I have a user "student@intersect.org.au" with profile "Student"
    And I have a user "deac@intersect.org.au"
    And "deac@intersect.org.au" is deactivated
    And I have access requests
      | email                       | first_name | last_name | title | other_initials | position | supervisor | group_school_institution | address | telephone  |
      | unapproved@intersect.org.au | Ryan       | Braganza  | Mr    | D              | TA       | Fred Jones |                          |         | 0411111111 |

  Scenario: Student can't do anything on users
    Given I am logged in as "student@intersect.org.au"
    Then I should get the following security outcomes
      | page                                             | outcome | message                                             |
      | the user details page for admin@intersect.org.au | error   | You do not have permissions to perform this action. |
      | the list users page                              | error   | You do not have permissions to perform this action. |
      | the edit profile page for admin@intersect.org.au | error   | You do not have permissions to perform this action. |
      | the access requests page                         | error   | You do not have permissions to perform this action. |

  Scenario: Administrator can view but not edit/approve/deactivate
    Given I am logged in as "admin@intersect.org.au"
    Then I should get the following security outcomes
      | page                                               | outcome | message                                             |
      | the user details page for student@intersect.org.au | ok      |                                                     |
      | the list users page                                | ok      |                                                     |
      | the edit profile page for admin@intersect.org.au   | error   | You do not have permissions to perform this action. |
      | the access requests page                           | ok      |                                                     |

  Scenario: Superuser can do everything
    Given I am logged in as "super@intersect.org.au"
    Then I should get the following security outcomes
      | page                                             | outcome | message |
      | the user details page for admin@intersect.org.au | ok      |         |
      | the list users page                              | ok      |         |
      | the edit profile page for admin@intersect.org.au | ok      |         |
      | the access requests page                         | ok      |         |

  Scenario: Student can't see List Approved Users or View Access Requests link on the admin page
    Given I am logged in as "student@intersect.org.au"
    When I am on the admin page
    Then I should not see link "List Approved Users"
    Then I should not see link "View Access Requests"

  Scenario: Administrator can see List Approved Users and View Access Requests link on the admin page
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    Then I should see link "List Approved Users"
    Then I should see link "View Access Requests"

  Scenario: Superuser can see List Approved Users and View Access Requests link on the admin page
    Given I am logged in as "super@intersect.org.au"
    When I am on the admin page
    Then I should see link "List Approved Users"
    Then I should see link "View Access Requests"

  Scenario: Administrator can see view links but not edit links on user list and user details
    Given I am logged in as "admin@intersect.org.au"
    When I am on the list users page
    Then I should see link "View Details"
    And I should not see link "Edit Profile"
    When I follow "View Details" for "student@intersect.org.au"
    Then I should not see link "Edit Profile"
    And I should not see link "Deactivate"
    When I follow "Back" within the main content
    And I follow "View Details" for "deac@intersect.org.au"
    Then I should not see link "Edit Profile"
    And I should not see link "Activate"

  Scenario: Superuser can see view and edit links on user list and user details
    Given I am logged in as "super@intersect.org.au"
    When I am on the list users page
    Then I should see link "View Details"
    And I should see link "Edit Profile"
    When I follow "View Details" for "student@intersect.org.au"
    Then I should see link "Edit Profile"
    And I should see link "Deactivate"
    When I follow "Back" within the main content
    And I follow "View Details" for "deac@intersect.org.au"
    Then I should see link "Edit Profile"
    And I should see link "Activate"

  Scenario: Administrator can see view links but not update links on access requests page
    Given I am logged in as "admin@intersect.org.au"
    When I am on the access requests page
    Then I should not see link "Approve"
    Then I should not see link "Reject"
    Then I should not see link "Reject as Spam"
    Then I should see link "View Details"
    When I follow "View Details" for "unapproved@intersect.org.au"
    Then I should not see link "Approve"
    Then I should not see link "Reject"
    Then I should not see link "Reject as Spam"

  Scenario: Superuser can see view and update links on access requests page
    Given I am logged in as "super@intersect.org.au"
    When I am on the access requests page
    Then I should see link "Approve"
    Then I should see link "Reject"
    Then I should see link "Reject as Spam"
    Then I should see link "View Details"
    When I follow "View Details" for "unapproved@intersect.org.au"
    Then I should see link "Approve"
    Then I should see link "Reject"
    Then I should see link "Reject as Spam"
