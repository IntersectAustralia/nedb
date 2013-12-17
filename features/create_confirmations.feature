@javascript
Feature: Create Confirmation
  In order to confirm a species details is correct
  As a user
  I want to confirm a determination

  Background:
    Given I have a specimen
    And I have people
      | first_name | last_name | middle_name | initials |
      | Greg       | Adams     | Robert      | G.R.     |
      | Fiona      | Wells     | Gary        | F.G.     |
      | Henry      | Smith     | Chris       | H.C.     |
    And I have species
      | division | class_name | order_name      | family       | sub_family | tribe  | genus       | name         | authority |
      | Div4     | Cls8       | Proteaceaeord   | Proteaceae   | Subf1      | Trb1   | Banksia     | integrifolia | Def       |
      | Div4     | Cls8       | Proteaceaeord   | Proteaceae   | Subf1      | Trb2   | Macadamia   | integrifolia | Ghi       |
    And the specimen has determination
      | determination_date_year | 2010         |
      | determiner              | G.R. Adams   |
      | species                 | integrifolia |
      | genus                   | Banksia      |
      | species_authority       | Def          |

    And I have herbaria
      | code | name                     |
      | NSW  | NSW Botanical Gardens    |
      | WOLL | University of Wollongong |
      | SCU  | DNA Bank                 |
      | UNC  | University of Newcastle  |

    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the specimen page

  Scenario: Add a confirmation
    When I follow "Add confirmation"
    And I click on the confirmers select box
    And I select "G.R. Adams" from the confirmers select
    And I fill in "confirmation_confirmation_date_year" with "2010"
    And I click on the confirmer's herbarium select box
    And I select "NSW - NSW Botanical Gardens" from the confirmer's herbarium select
    And I press "Create Confirmation"
    Then I should see "Confirmation was successfully created."

  Scenario: Add a confirmation by using the auto complete
    When I follow "Add confirmation"
    And I click on the confirmers select box
    And I fill in the confirmer search box with "F.G."
    Then I should see "F.G. Wells"
    When I select "F.G. Wells" from the confirmers select
    And I fill in "confirmation_confirmation_date_year" with "2010"
    And I click on the confirmer's herbarium select box
    And I fill in the confirmer's herbarium search box with "University"
    Then I should see "WOLL - University of Wollongong"
    And I should see "UNC - University of Newcastle"
    Then I select "WOLL - University of Wollongong" from the confirmer's herbarium select
    And I press "Create Confirmation"
    Then I should see "Confirmation was successfully created."

  Scenario: Create confirmation with validation issues
    When I follow "Add confirmation"
    And press "Create Confirmation"
    Then I should see "Confirmer can't be blank"
    And I should see "Enter a year for Confirmation date"
    And I fill in "confirmation_confirmation_date_day" with "asd"
    And I fill in "confirmation_confirmation_date_month" with "asd"
    And I fill in "confirmation_confirmation_date_year" with "asd"
    And I press "Create Confirmation"
    Then I should see "Confirmation date day is not a number"
    And I should see "Confirmation date month is not a number"
    And I should see "Confirmation date year is not a number"