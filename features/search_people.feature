Feature: Search People
  In order to quickly find a person(s)
  As a user
  I want to use the quick search option under manage people

  Background:
    Given I have people
      | first_name | middle_name | last_name | email           | initials  |
      | James      | Harry       | Brown     | james@gmail.com | J.H.      |
      | Donald     |             | Duck      | donald@gmail.com| D.        |
      | Tom        |             | Cat       | tom@gmail.com   | T.        |
      | Double     | Trouble     | Bubble    | double@gmail.com| D.T.      |
      | Double     | Trouble     | Again     | double@gmail.com| D.T.      |

    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the homepage
    When I follow "Admin"
    And I follow "Manage People"
    Then I should see "People"

  Scenario: Search for valid person
    Given I am on the people page
    When I do a quick search for person "james"
    Then I should see "James"
    And I should see "Harry"
    And I should see "Brown"
    And I should see "james@gmail.com"

  Scenario: Search for non existing person
    Given I am on the people page
    When I do a quick search for person "steve"
    Then I should see "No person was found for text search 'steve'"

  Scenario: Search without entering a search term returns all people
    Given I am on the people page
    When I do a quick search for person " "
    And the people table should contain
      | First name  | Middle name | Last name |
      | Double      | Trouble     | Again     |
      | James       | Harry       | Brown     |
      | Double      | Trouble     | Bubble    |
      | Tom         |             | Cat       |
      | Donald      |             | Duck      |
    And I should see "Showing all 5 person(s)."

  Scenario: Search that returns multiple search results redirects to the result set page
    Given I am on the people page
    When I do a quick search for person "double"
    And the people table should contain
      | First name  | Middle name | Last name |
      | Double      | Trouble     | Again     |
      | Double      | Trouble     | Bubble    |

  Scenario: Searching people returns an ordered list by display name
    Given I am on the people page
    When I do a quick search for person " "
    And the people table should contain
      | First name  | Middle name | Last name | Display name |
      | Double      | Trouble     | Again     | D.T. Again   |
      | James       | Harry       | Brown     | J.H. Brown   |
      | Double      | Trouble     | Bubble    | D.T. Bubble  |
      | Tom         |             | Cat       | T. Cat       |
      | Donald      |             | Duck      | D. Duck      |