Feature: Display of menu bar items
  In order to make the system usable
  As the system owner
  I want the menu bar to only show things the user can do

  Background:
    Given I have profiles
      | name          |
      | Superuser     |
      | Administrator |
      | Student       |
    And I have permissions
      | entity   | action | profiles                 |
      | Specimen | create | Superuser, Administrator |
      | User     | read   | Administrator            |
      | Person   | read   | Superuser                |
    # REVIEWME
    # Given I have the usual profiles and permissions
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"
    And I have a user "student@intersect.org.au" with profile "Student"

  Scenario: Student can see home and search
    Given I am logged in as "student@intersect.org.au"
    Then I should see link "Home" inside the nav bar
    And I should see link "Search" inside the nav bar
    And I should see link "Latest 40" inside the nav bar
    And I should not see link "Add" inside the nav bar
    # REVIEWME
    # And I should see link "Add" inside the nav bar
    And I should not see link "Admin" inside the nav bar
    And I should see link "Advanced Search" inside the nav bar

  Scenario: Administrator can see all
    Given I am logged in as "admin@intersect.org.au"
    Then I should see link "Home" inside the nav bar
    And I should see link "Search" inside the nav bar
    And I should see link "Latest 40" inside the nav bar
    And I should see link "Add" inside the nav bar
    And I should see link "Admin" inside the nav bar
    And I should see link "Advanced Search" inside the nav bar

  Scenario: Superuser can see all
    Given I am logged in as "super@intersect.org.au"
    Then I should see link "Home" inside the nav bar
    And I should see link "Search" inside the nav bar
    And I should see link "Latest 40" inside the nav bar
    And I should see link "Add" inside the nav bar
    And I should see link "Admin" inside the nav bar
    And I should see link "Advanced Search" inside the nav bar

  Scenario: User who is not logged in
    Given I am on the home page
    Then I should see link "Home" inside the nav bar
    And I should not see link "Search" inside the nav bar
    And I should not see link "Latest 40" inside the nav bar
    And I should not see link "Add" inside the nav bar
    And I should not see link "Admin" inside the nav bar
    And I should not see link "Advanced Search" inside the nav bar

  Scenario: Student should not see "create specimen" link on home page
    Given I am logged in as "student@intersect.org.au"
    Then I should not see link "Create a specimen"
    # REVIEWME
    # Then I should see link "Create a specimen"

  Scenario: Administrator should see "create specimen" link on home page
    Given I am logged in as "admin@intersect.org.au"
    Then I should see link "Create a specimen"
