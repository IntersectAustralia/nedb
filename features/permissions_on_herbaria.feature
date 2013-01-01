Feature: Permissions to manage people
  In order to keep the system secure
  As the system owner
  I want to restrict access to the people management functionality

  Background:
    Given I have the usual profiles and permissions
    And I have herbaria
      | code | name                     |
      | NSW  | NSW Botanical Gardens    |
      | WOLL | University of Wollongong |
      | SCU  | DNA Bank                 |
      | UNC  | University of Newcastle  |
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"
    And I have a user "student@intersect.org.au" with profile "Student"

  Scenario: Student can't do anything on herbaria
    Given I am logged in as "student@intersect.org.au"
    Then I should get the following security outcomes
      | page                               | outcome | message                                             |
      | the edit herbarium page for "WOLL" | error   | You do not have permissions to perform this action. |
      | the create herbarium page          | error   | You do not have permissions to perform this action. |
      | the list herbaria page             | error   | You do not have permissions to perform this action. |

  Scenario: Administrator can view but not edit/create
    Given I am logged in as "admin@intersect.org.au"
    Then I should get the following security outcomes
      | page                               | outcome | message                                             |
      | the edit herbarium page for "WOLL" | error   | You do not have permissions to perform this action. |
      | the create herbarium page          | error   | You do not have permissions to perform this action. |
      | the list herbaria page             | ok      |                                                     |

  Scenario: Superuser can do everything
    Given I am logged in as "super@intersect.org.au"
    Then I should get the following security outcomes
      | page                               | outcome | message |
      | the edit herbarium page for "WOLL" | ok      |         |
      | the create herbarium page          | ok      |         |
      | the list herbaria page             | ok      |         |

  Scenario: Student can't see Manage Herbaria link on the admin page
    Given I am logged in as "student@intersect.org.au"
    When I am on the admin page
    Then I should not see link "Manage Herbaria"

  Scenario: Administrator can see Manage Herbaria link on the admin page
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    Then I should see link "Manage Herbaria"

  Scenario: Administrator can see view links but not create or edit
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    And I follow "Manage Herbaria"
    Then I should not see link "Add Another Herbarium"
    And I should not see link "Edit"

  Scenario: Administrator can search herbaria
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    Then I follow "Manage Herbaria"
    And I should see "List of Herbaria"
    And I press "Go"
    Then I should see "Showing all 4 herbaria"

  Scenario: Superuser can search herbaria
    Given I am logged in as "super@intersect.org.au"
    When I am on the admin page
    Then I follow "Manage Herbaria"
    And I should see "List of Herbaria"
    And I press "Go"
    Then I should see "Showing all 4 herbaria"
