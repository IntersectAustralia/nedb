Feature: View Latest 40 Specimens
  In order to quickly view new specimens added to the system
  As a user
  I want to use the latest 40 option

  Background:
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Should not see more than 40 specimens
    Given I have 50 specimens
    And I am on the home page
    And I follow "Latest 40"
    And I should see "Showing latest 40 specimens in descending order"
    Then I should not see "BotDiv 1."
    Then I should not see "BotDiv 10."
    Then I should see "BotDiv 11."
    Then I should see "BotDiv 50."

  Scenario: Should not see more than 40 specimens
    Given I have 30 specimens
    And I am on the home page
    And I follow "Latest 40"
    And I should see "Showing latest 40 specimens in descending order"
    Then I should see "BotDiv 1."
    Then I should see "BotDiv 30."

  Scenario: Modifying specimen items bumps specimen to the top
    Given I have specimens
      | tag        | botanical_division |
      | Specimen 1 | BotDiv 1.          |
      | Specimen 2 | BotDiv 2.          |
    And I have item types Silica Gel, Photo, Fruit, Plants
    And I am on the latest specimens page
    And I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 2.          |
      | BotDiv 1.          |
    And I am on the specimen page for "Specimen 1"
    And I press "Add"
    And I should see "The item was successfully added."
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 2.          |
    Given I have specimens
      | tag        | botanical_division |
      | Specimen 3 | BotDiv 3.          |
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 3.          |
      | BotDiv 1.          |
      | BotDiv 2.          |
    And I am on the specimen page for "Specimen 1"
    And I follow "Delete"
    And I should see "The item was successfully deleted."
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 3.          |
      | BotDiv 2.          |

  Scenario: Modifying specimen images bumps specimen to the top
    Given I have specimens
      | tag        | botanical_division |
      | Specimen 1 | BotDiv 1.          |
      | Specimen 2 | BotDiv 2.          |
    And I am on the latest specimens page
    And I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 2.          |
      | BotDiv 1.          |
    And I am on the specimen page for "Specimen 1"
    When I follow "Add Image"
    Then I should see "Upload New Image"
    When I attach an image file
    And I fill in "Description" with "desc1"
    And I press "Upload"
    Then I should see "The specimen image was uploaded successfully."
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 2.          |
    And I have specimens
      | tag        | botanical_division |
      | Specimen 3 | BotDiv 3.          |
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 3.          |
      | BotDiv 1.          |
      | BotDiv 2.          |
    And I am on the view specimen image page for "Specimen 1"
    And I follow "Edit Description"
    And I fill in "Description" with "test description"
    And I press "Save"
    And I should see "The specimen image description was successfully updated."
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 3.          |
      | BotDiv 2.          |

    And I have specimens
      | tag        | botanical_division |
      | Specimen 4 | BotDiv 4.          |
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 4.          |
      | BotDiv 1.          |
      | BotDiv 3.          |
      | BotDiv 2.          |
    And I am on the view specimen image page for "Specimen 1"
    And I follow "Delete Image"
    And I should see "The image was successfully deleted."
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 4.          |
      | BotDiv 3.          |
      | BotDiv 2.          |

  Scenario: Modifying specimen replicates bumps specimen to the top
    Given I have specimens
      | tag        | botanical_division |
      | Specimen 1 | BotDiv 1.          |
      | Specimen 2 | BotDiv 2.          |
    And I am on the latest specimens page
    And I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 2.          |
      | BotDiv 1.          |
    And I am on the specimen page for "Specimen 1"
    And I follow "Edit Replicates"
    And I press "Update Specimen"
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 2.          |

  @javascript
  Scenario: Modifying specimen determinations and confirmations bump specimen to the top
    Given I have specimens
      | tag        | botanical_division |
      | Specimen 1 | BotDiv 1.          |
      | Specimen 2 | BotDiv 2.          |
#    And "Specimen 1" has a determination with string "abcd"
    And I have people
      | first_name | last_name | middle_name | initials |
      | Greg       | Adams     | Robert      | G.R.     |
      | Fiona      | Wells     | Gary        | F.G.     |
      | Henry      | Smith     | Chris       | H.C.     |
    And I have herbaria
      | code | name                  |
      | NSW  | NSW Botanical Gardens |
    And I have species
      | division | class_name | order_name  | family   | sub_family | tribe  | genus | name | authority |
      | Div4     | Cls8       | Rosaceaeord | Rosaceae | Subf2      | Tribe2 | Dryas | abcd | Mno       |
    And species "abcd" has forms
      | form  | authority |
      | form1 | f1 auth   |
    And species "abcd" has subspecies
      | subspecies | authority |
      | subsp1     | s1 auth   |
    And species "abcd" has varieties
      | variety | authority |
      | var1    | v1 auth   |
    And I have an uncertainty type "aff."
    And I am on the latest specimens page
    And I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 2.          |
      | BotDiv 1.          |
    And I am on the specimen page for "Specimen 1"
    And I follow "Add Determination"
    And I select "G.R. Adams" from the determiners select
    When I fill in "determination_determination_date_year" with "2010"
    When I fill in "determination_determination_date_month" with "3"
    When I fill in "determination_determination_date_day" with "25"
    And I select "NSW - NSW Botanical Gardens" from "Determiner herbarium"
    And I press "Continue"
    And I select "Division" from "level"
    And I fill in "term" with "Div4"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division |        |
      | Div4     | Select |
    When I select the first result in the species search results
    And I wait for a while
    Then I should see field "Division" with value "Div4"
    And I press "Save"
    Then I should see "Determination was successfully created"
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 2.          |
    Given I have specimens
      | tag        | botanical_division |
      | Specimen 3 | BotDiv 3.          |
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 3.          |
      | BotDiv 1.          |
      | BotDiv 2.          |
    And I am on the specimen page for "Specimen 1"
    And I follow "Edit determination"
    And I press "Continue"
    When I press "Save"
    And I should see "Determination was successfully updated"
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 3.          |
      | BotDiv 2.          |

    Given I have specimens
      | tag        | botanical_division |
      | Specimen 4 | BotDiv 4.          |
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 4.          |
      | BotDiv 1.          |
      | BotDiv 3.          |
      | BotDiv 2.          |
    And I am on the specimen page for "Specimen 1"
    And I follow "Add confirmation"
    And I select "H.C. Smith" from the confirmer select
    And I fill in "confirmation_confirmation_date_day" with "1"
    And I fill in "confirmation_confirmation_date_month" with "1"
    And I fill in "confirmation_confirmation_date_year" with "2013"
    And I press "Create Confirmation"
    And I should see "Confirmation was successfully created"
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 4.          |
      | BotDiv 3.          |
      | BotDiv 2.          |
    Given I have specimens
      | tag        | botanical_division |
      | Specimen 5 | BotDiv 5.          |
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 5.          |
      | BotDiv 1.          |
      | BotDiv 4.          |
      | BotDiv 3.          |
      | BotDiv 2.          |
    And I am on the specimen page for "Specimen 1"
    And I follow "Edit confirmation"
    And I press "Update Confirmation"
    And I should see "Confirmation was successfully updated"
    And I am on the latest specimens page
    Then I should see "search_results_table" table with
      | Botanical Division |
      | BotDiv 1.          |
      | BotDiv 5.          |
      | BotDiv 4.          |
      | BotDiv 3.          |
      | BotDiv 2.          |

