Feature: Permissions to manage species
  In order to keep the system secure
  As the system owner
  I want to restrict access to the species management functionality

  Background:
    Given I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity  | action  | profiles                 |
      | Species | read    | Superuser, Administrator |
      | Species | create  | Superuser                |
      | Species | update  | Superuser                |
      | Species | destroy | Superuser                |
    And I have species
      | name         |
      | integrifolia |
      | victoriae    |
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"
    And I have a user "student@intersect.org.au" with profile "Student"

  Scenario: Student can't do anything on species
    Given I am logged in as "student@intersect.org.au"
    Then I should get the following security outcomes
      | page                                     | outcome | message                                             |
      | the species page for "integrifolia"      | error   | You do not have permissions to perform this action. |
      | the edit species page for "integrifolia" | error   | You do not have permissions to perform this action. |
      | the create species page                  | error   | You do not have permissions to perform this action. |
      | the list species page                    | error   | You do not have permissions to perform this action. |

  Scenario: Administrator can view but not edit/create
    Given I am logged in as "admin@intersect.org.au"
    Then I should get the following security outcomes
      | page                                     | outcome | message                                             |
      | the species page for "integrifolia"      | ok      |                                                     |
      | the edit species page for "integrifolia" | error   | You do not have permissions to perform this action. |
      | the create species page                  | error   | You do not have permissions to perform this action. |
      | the list species page                    | ok      |                                                     |

  Scenario: Superuser can do everything
    Given I am logged in as "super@intersect.org.au"
    Then I should get the following security outcomes
      | page                                     | outcome | message |
      | the species page for "integrifolia"      | ok      |         |
      | the edit species page for "integrifolia" | ok      |         |
      | the create species page                  | ok      |         |
      | the list species page                    | ok      |         |

  Scenario: Student can't see Manage Species link on the admin page
    Given I am logged in as "student@intersect.org.au"
    When I am on the admin page
    Then I should not see link "Manage Species"

  Scenario: Administrator can see Manage Species link on the admin page
    Given I am logged in as "admin@intersect.org.au"
    When I am on the admin page
    Then I should see link "Manage Species"

  Scenario: Administrator can see view links but not create or edit
    Given I am logged in as "admin@intersect.org.au"
    And I am on the admin page
    When I follow "Manage Species"
    And I do a species search for "a"
    Then I should not see link "Create New Species"
    And I should not see link "Edit"
    And I should not see link "Delete"
    And I should see link "View"
    When I am on the species page for "integrifolia"
    Then I should not see link "Edit"
    And I should not see link "Delete"

  Scenario: Superuser can see view all links
    Given I am logged in as "super@intersect.org.au"
    When I am on the admin page
    And I follow "Manage Species"
    And I do a species search for "a"
    Then I should see link "Create New Species"
    And I should see link "Edit"
    And I should see link "Delete"
    And I should see link "View"
    When I am on the species page for "integrifolia"
    Then I should see link "Edit"
    And I should see link "Delete"


