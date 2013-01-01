Feature: Manage Items
  In order to track the items for a specimen
  As a user
  I want to manage items
  
  Background:
    Given I have a specimen
    And I have item types Silica Gel, Photo, Fruit, Plants
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
  
  Scenario: Add Items
    Given I am on the specimen page
    When I select "Silica Gel" from "item_type_id"
    And I press "Add"
    Then I should see "The item was successfully added."
    And I should see items table
        | Silica Gel |

  Scenario: Add Multiple Items
    Given I am on the specimen page
    When I select "Silica Gel" from "item_type_id"
    And I press "Add"
    When I select "Photo" from "item_type_id"
    And I press "Add"
    When I select "Fruit" from "item_type_id"
    And I press "Add"
    When I select "Silica Gel" from "item_type_id"
    And I press "Add"
    Then I should see items table
        | Fruit      |
        | Photo      |
        | Silica Gel |
        | Silica Gel |

