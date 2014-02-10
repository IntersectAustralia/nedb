Feature: Permissions to manage people
  In order to keep the system secure
  As the system owner
  I want to restrict access to the people management functionality

  Background:
    Given I have the usual profiles and permissions
    And I have people
      | initials |  last_name  |
      | G.R.     |  Adams      |
      | F.G.     |  Wells      |
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"
    And I have a user "student@intersect.org.au" with profile "Student"

  Scenario: Student can't do anything on people
    Given I am logged in as "student@intersect.org.au"
    Then I should get the following security outcomes
      | page                                  | outcome | message                                             |
      | the person page for "Adams"           | error   | You do not have permissions to perform this action. |
      | the edit person page for "Adams"      | error   | You do not have permissions to perform this action. |
      | the create person page                | error   | You do not have permissions to perform this action. |
      | the list people page                  | error   | You do not have permissions to perform this action. |

  Scenario: Administrator can view but not edit/create
    Given I am logged in as "admin@intersect.org.au"
    Then I should get the following security outcomes
      | page                                  | outcome | message                                             |
      | the person page for "Adams"           | ok      |                                                     |
      | the edit person page for "Adams"      | error   | You do not have permissions to perform this action. |
      | the create person page                | error   | You do not have permissions to perform this action. |
      | the list people page                  | ok      |                                                     |

  Scenario: Superuser can do everything
    Given I am logged in as "super@intersect.org.au"
    Then I should get the following security outcomes
      | page                                  | outcome | message |
      | the person page for "Adams"           | ok      |         |
      | the edit person page for "Adams"      | ok      |         |
      | the create person page                | ok      |         |
      | the list people page                  | ok      |         |

  Scenario: Student can't see Manage People link on the admin page
    Given I am logged in as "student@intersect.org.au"
    When I am on the admin page
    Then I should not see link "Manage People"

  Scenario: Administrator can see Manage People link on the admin page
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    Then I should see link "Manage People"

  Scenario: Administrator can see view links but not create or edit
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    And I follow "Manage People"
    Then I should not see link "Create New Person"
    And I should not see link "Edit"
    And I should see link "View"


