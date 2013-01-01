Feature: Administer People
  In order to manage people in the system
  As a user
  I want to view and edit people

  Background:
    Given I have people
      | first_name | middle_name | last_name |  initials | email           |
      | James      | Harry       | Brown     | J.H.      | james@gmail.com |
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the homepage
    When I follow "Admin"
    And I follow "Manage People"
    Then I should see "People"

  Scenario: View people
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Display name | Email           |
      | James      | Harry       | Brown     | J.H. Brown   |james@gmail.com  |

  Scenario: View person
    When I follow the view link for person "james@gmail.com"
    Then I should see "Person Details"
    And I should see field "First name" with value "James"
    And I should see field "Last name" with value "Brown"
    And I should see field "Middle name" with value "Harry"
    And I should see field "Email" with value "james@gmail.com"

  Scenario: View person and use back link
    When I follow the view link for person "james@gmail.com"
    Then I should see "Person Details"
    When I follow "Back" within the main content
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Email           |
      | James      | Harry       | Brown     | james@gmail.com |

  Scenario: Edit person details
    When I follow the edit link for person "james@gmail.com"
    Then I should see "Edit Person"
    And I fill in "First name" with "Clint"
    And I fill in "Last name" with "Eastwood"
    And I fill in "Middle name" with "Gerald"
    And I fill in "Initials" with "C.G."
    And I fill in "Email" with "clint@hotmail.com"
    And I press "Update Person"
    Then I should see "Person was successfully updated."
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Display name  | Email              |
      | Clint      | Gerald      | Eastwood  | C.G. Eastwood | clint@hotmail.com  |

  Scenario: Cancel an edit
    When I follow the edit link for person "james@gmail.com"
    Then I should see "Edit Person"
    And I fill in "First name" with "Clint"
    And I fill in "Last name" with "Eastwood"
    And I fill in "Middle name" with "Gerald"
    And I fill in "Email" with "clint@hotmail.com"
    And I follow "Cancel"
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Email           |
      | James      | Harry       | Brown     | james@gmail.com |

  Scenario: Delete a person
    When I follow "Delete"
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Email |
    And I should see "Person was successfully deleted."

  Scenario: Delete a person with a specimen
    Given the person "james@gmail.com" has a specimen
    When I follow "Delete"
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Email |
      | James      | Harry       | Brown     | james@gmail.com |
    And I should see "Person could not be deleted as it is still being referenced."

  Scenario: Delete a person with a confirmation
    Given the person "james@gmail.com" has a confirmation
    When I follow "Delete"
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Email |
      | James      | Harry       | Brown     | james@gmail.com |
    And I should see "Person could not be deleted as it is still being referenced."

  Scenario: Delete a person with a determination
    Given the person "james@gmail.com" has a determination
    When I follow "Delete"
    Then I should see "people_table" table with
      | First name | Middle name | Last name | Email |
      | James      | Harry       | Brown     | james@gmail.com |
    And I should see "Person could not be deleted as it is still being referenced."
