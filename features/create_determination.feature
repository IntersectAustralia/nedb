@javascript
Feature: Create Determination
  In order to
  As a user
  I want to

  Background:
    Given I have a specimen
    And I have people
      | first_name | last_name | middle_name | initials |
      | Greg       | Adams     | Robert      | G.R.     |
      | Fiona      | Wells     | Gary        | F.G.     |
      | Henry      | Smith     | Chris       | H.C.     |
    And I have herbaria
      | code | name                     |
      | NSW  | NSW Botanical Gardens    |
      | WOLL | University of Wollongong |
      | SCU  | DNA Bank                 |
      | UNC  | University of Newcastle  |
    And I have species
      | division | class_name | order_name      | family       | sub_family | tribe  | genus       | name         | authority |
      | Div4     | Cls8       | Proteaceaeord   | Proteaceae   | Subf1      | Trb1   | Banksia     | integrifolia | Def       |
      | Div4     | Cls8       | Proteaceaeord   | Proteaceae   | Subf1      | Trb2   | Macadamia   | integrifolia | Ghi       |
      | Div2     | Cls5       | Asteraceaeord   | Asteraceae   |            |        | Andryala    | integrifolia | F.Smith   |
      | Div4     | Cls7       | Hedwigiaceaeord | Hedwigiaceae |            |        | Hedwigia    | integrifolia | R.Br      |
      | Div4     | Cls7       | Malvaceaeord    | Malvaceae    | Subf3      |        | Keraudrenia | integrifolia | Abc       |
      | Div4     | Cls8       | Rosaceaeord     | Rosaceae     | Subf2      | Tribe2 | Dryas       | integrifolia | Jkl       |
      | Div4     | Cls8       | Rosaceaeord     | Rosaceae     | Subf2      | Tribe2 | Dryas       | abcd         | Mno       |
      | Div4     | Cls8       | Rosaceaeord     | Rosaceae     | Subf2      | Tribe2 | Dryas       | efgh         | Pq        |
    And species "abcd" has forms
      | form  | authority |
      | form1 | f1 auth   |
      | form2 | f2 auth   |
      | form3 | f3 auth   |
    And species "abcd" has subspecies
      | subspecies | authority |
      | subsp1     | s1 auth   |
      | subsp2     | s2 auth   |
      | subsp3     | s3 auth   |
    And species "abcd" has varieties
      | variety | authority |
      | var1    | v1 auth   |
      | var2    | v2 auth   |
      | var3    | v3 auth   |
    And I have an uncertainty type "?"
    And I have an uncertainty type "sens. strict."
    And I have an uncertainty type "sens. lat."
    And I have an uncertainty type "vel. aff."
    And I have an uncertainty type "aff."
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Should not get past step 1 without passing date validation
    Given I am on the specimen page
    When I follow "Add Determination"
    And I select "G.R. Adams" from the determiners select
    And I press "Continue"
    Then I should see "Enter a year for Determination date"
    And I should see "Step 1:"
    When I fill in "determination_determination_date_year" with "2010"
    And I press "Continue"
    Then I should see "Step 2:"

  Scenario: Should not get past step 1 without passing determiners validation
    Given I am on the specimen page
    When I follow "Add Determination"
    And I fill in "determination_determination_date_year" with "2010"
    And I press "Continue"
    Then I should see "Determiners can't be blank"
    And I should see "Step 1:"
    And I select "G.R. Adams" from the determiners select
    And I press "Continue"
    Then I should see "Step 2:"

  Scenario: Save without a plant name
    Given I am on the specimen page
    When I follow "Add Determination"
    And I select "G.R. Adams" from the determiners select
    And I select "F.G. Wells" from the determiners select
    When I fill in "determination_determination_date_year" with "2010"
    When I fill in "determination_determination_date_month" with "3"
    When I fill in "determination_determination_date_day" with "25"
    And I select "NSW - NSW Botanical Gardens" from "Determiner herbarium"
    And I press "Continue"
    And I press "Save"
    Then I should see "Determination was successfully created"
    And I should see a determination table with
      | Date Determined | Determiners            | Determiner Herbarium | Date Confirmed | Confirmer | Confirmer Herbarium |
      | 25 Mar. 2010    | G.R. Adams, F.G. Wells | NSW                  |                |           |                     |
    But I should not see "Division"

  Scenario: Search by division
    Given I am at step 2 of adding a determination
    And I select "Division" from "level"
    And I fill in "term" with "Div4"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division |        |
      | Div4     | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should not see "Class"
    And I should see a determination table with
      | Date Determined | Determiners            | Determiner Herbarium | Date Confirmed | Confirmer | Confirmer Herbarium |
      | 2010            | G.R. Adams, F.G. Wells |                      |                |           |                     |

  Scenario: Search by class
    Given I am at step 2 of adding a determination
    When I select "Class" from "level"
    And I fill in "term" with "Cls7"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class |        |
      | Div4     | Cls7  | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should not see "Order"

  Scenario: Search by order
    Given I am at step 2 of adding a determination
    When I select "Order" from "level"
    And I fill in "term" with "Rosaceaeord"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order       |        |
      | Div4     | Cls8  | Rosaceaeord | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Rosaceaeord"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Rosaceaeord"
    But I should not see "Family"

  Scenario: Search by family
    Given I am at step 2 of adding a determination
    When I select "Family" from "level"
    And I fill in "term" with "Proteaceae"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order         | Family     |        |
      | Div4     | Cls8  | Proteaceaeord | Proteaceae | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    And I should see uncertainty radio buttons for "family"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    But I should not see "Subfamily"

  Scenario: Search by subfamily
    Given I am at step 2 of adding a determination
    When I select "Subfamily" from "level"
    And I fill in "term" with "Subf3"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order        | Family    | Subfamily |        |
      | Div4     | Cls7  | Malvaceaeord | Malvaceae | Subf3     | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Malvaceaeord"
    And I should see field "Family" with value "Malvaceae"
    And I should see field "Subfamily" with value "Subf3"
    And I should see uncertainty radio buttons for "subfamily"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Malvaceaeord"
    And I should see field "Family" with value "Malvaceae"
    And I should see field "Subfamily" with value "Subf3"
    But I should not see "Tribe"

  Scenario: Search by tribe
    Given I am at step 2 of adding a determination
    When I select "Tribe" from "level"
    And I fill in "term" with "Trb1"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order         | Family     | Subfamily | Tribe |        |
      | Div4     | Cls8  | Proteaceaeord | Proteaceae | Subf1     | Trb1  | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    And I should see field "Subfamily" with value "Subf1"
    And I should see field "Tribe" with value "Trb1"
    And I should see uncertainty radio buttons for "tribe"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    And I should see field "Subfamily" with value "Subf1"
    And I should see field "Tribe" with value "Trb1"
    But I should not see "Genus"

  Scenario: Search by genus
    Given I am at step 2 of adding a determination
    When I select "Genus" from "level"
    And I fill in "term" with "Dryas"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order       | Family   | Subfamily | Tribe  | Genus |        |
      | Div4     | Cls8  | Rosaceaeord | Rosaceae | Subf2     | Tribe2 | Dryas | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Rosaceaeord"
    And I should see field "Family" with value "Rosaceae"
    And I should see field "Subfamily" with value "Subf2"
    And I should see field "Tribe" with value "Tribe2"
    And I should see field "Genus" with value "Dryas"
    And I should see uncertainty radio buttons for "genus"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Rosaceaeord"
    And I should see field "Family" with value "Rosaceae"
    And I should see field "Subfamily" with value "Subf2"
    And I should see field "Tribe" with value "Tribe2"
    And I should see field "Genus" with value "Dryas"
    But I should not see "Species"

  Scenario: Search by species
    Given I am at step 2 of adding a determination
    When I select "Species" from "level"
    And I fill in "term" with "integrifolia"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order           | Family       | Subfamily | Tribe  | Genus       | Species      | Authority |        |
      | Div2     | Cls5  | Asteraceaeord   | Asteraceae   |           |        | Andryala    | integrifolia | F.Smith   | Select |
      | Div4     | Cls8  | Proteaceaeord   | Proteaceae   | Subf1     | Trb1   | Banksia     | integrifolia | Def       | Select |
      | Div4     | Cls8  | Rosaceaeord     | Rosaceae     | Subf2     | Tribe2 | Dryas       | integrifolia | Jkl       | Select |
      | Div4     | Cls7  | Hedwigiaceaeord | Hedwigiaceae |           |        | Hedwigia    | integrifolia | R.Br      | Select |
      | Div4     | Cls7  | Malvaceaeord    | Malvaceae    | Subf3     |        | Keraudrenia | integrifolia | Abc       | Select |
      | Div4     | Cls8  | Proteaceaeord   | Proteaceae   | Subf1     | Trb2   | Macadamia   | integrifolia | Ghi       | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div2"
    And I should see field "Class" with value "Cls5"
    And I should see field "Order" with value "Asteraceaeord"
    And I should see field "Family" with value "Asteraceae"
    And I should see field "Subfamily" with value ""
    And I should see field "Tribe" with value ""
    And I should see field "Genus" with value "Andryala"
    And I should see field "Species" with value "integrifolia"
    And I should see field "Species Authority" with value "F.Smith"
    And I should see uncertainty radio buttons for "species"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div2"
    And I should see field "Class" with value "Cls5"
    And I should see field "Order" with value "Asteraceaeord"
    And I should see field "Family" with value "Asteraceae"
    And I should see field "Genus" with value "Andryala"
    And I should see field "Species" with value "integrifolia"
    And I should see field "Species Authority" with value "F.Smith"

  Scenario: Setting subspecies, variety, form
    Given I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with "abcd"
    And I press "Search" within the main content
    When I select the first result in the species search results
    When I select "subsp1 - s1 auth" from "Subspecies"
    And I select "var2 - v2 auth" from "Variety"
    And I select "form3 - f3 auth" from "Form"
  # TODO should see each drop down with correct values
    And I should see uncertainty radio buttons for "subspecies"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    And I should see uncertainty radio buttons for "variety"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    And I should see uncertainty radio buttons for "form"
      | uncertainty   |
      | ?             |
      | sens. strict. |
      | sens. lat.    |
      | vel. aff.     |
      | aff.          |
    And I press "Save"
    Then I should be on the specimen page
    And I should see field "Subspecies" with value "subsp. subsp1 s1 auth"
    And I should see field "Variety" with value "var. var2 v2 auth"
    And I should see field "Form" with value "f. form3 f3 auth"

  Scenario: Family uncertainty should be saved and displayed correctly
    Given I am at step 2 of adding a determination
    And I select "Family" from "level"
    And I fill in "term" with "Proteaceae"
    And I press "Search" within the main content
    When I select the first result in the species search results
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Family" with value "?Proteaceae"
    And the specimen title should include "?Proteaceae"
    When I follow "View"
    Then I should see field "Family" with value "?Proteaceae"

  Scenario: Subfamily uncertainty should be saved and displayed correctly
    Given I am at step 2 of adding a determination
    And I select "Subfamily" from "level"
    And I fill in "term" with "Subf3"
    And I press "Search" within the main content
    When I select the first result in the species search results
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Subfamily" with value "?Subf3"
    And the specimen title should include "Malvaceae subfam. ?Subf3"
    When I follow "View"
    Then I should see field "Subfamily" with value "?Subf3"

  Scenario: Tribe uncertainty should be saved and displayed correctly
    Given I am at step 2 of adding a determination
    And I select "Tribe" from "level"
    And I fill in "term" with "Trb1"
    And I press "Search" within the main content
    When I select the first result in the species search results
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Tribe" with value "?Trb1"
    And the specimen title should include "Proteaceae subfam. Subf1"
    And the specimen title should include "?Trb1"
    When I follow "View"
    Then I should see field "Tribe" with value "?Trb1"

  Scenario: Genus uncertainty should be saved and displayed correctly
    Given I am at step 2 of adding a determination
    And I select "Genus" from "level"
    And I fill in "term" with "Dryas"
    And I press "Search" within the main content
    When I select the first result in the species search results
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Genus" with value "?Dryas"
    And the specimen title should include "Rosaceae subfam. Subf2"
    And the specimen title should include "Tribe2 ?Dryas"
    When I follow "View"
    Then I should see field "Genus" with value "?Dryas"

  Scenario: Species uncertainty should be saved and displayed correctly
    Given I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with "integrifolia"
    And I press "Search" within the main content
    When I select the first result in the species search results
    And I choose "sens. strict."
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Species" with value "integrifolia s. str."
    And the specimen title should include "Asteraceae"
    And the specimen title should include "Andryala integrifolia F.Smith s. str."
    When I follow "View"
    Then I should see field "Species" with value "integrifolia s. str."

  Scenario: Subspecies, variety, form uncertainties should be saved and displayed correctly
    Given I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with "abcd"
    And I press "Search" within the main content
    When I select the first result in the species search results
    And I select "subsp1 - s1 auth" from "Subspecies"
    And I select "var2 - v2 auth" from "Variety"
    And I select "form3 - f3 auth" from "Form"
    And I choose "sens. lat." within "#display_subspecies_uncertainty"
    And I choose "vel. aff." within "#display_variety_uncertainty"
    And I choose "aff." within "#display_form_uncertainty"
    And I press "Save"
    Then I should be on the specimen page
    And I should see field "Subspecies" with value "subsp. subsp1 s. lat. s1 auth"
    And I should see field "Variety" with value "var. var2 vel. aff. v2 auth"
    And I should see field "Form" with value "f. aff. form3 f3 auth"
    And the specimen title should include "Rosaceae subfam. Subf2"
    And the specimen title should include "Tribe2 Dryas abcd Mno"
    And the specimen title should include "subsp. subsp1 s. lat. s1 auth"
    And the specimen title should include "var. var2 vel. aff. v2 auth"
    And the specimen title should include "f. aff. form3 f3 auth"
    When I follow "View"
    Then I should see field "Subspecies" with value "subsp. subsp1 s. lat. s1 auth"
    And I should see field "Variety" with value "var. var2 vel. aff. v2 auth"
    And I should see field "Form" with value "f. aff. form3 f3 auth"

  Scenario: search type and term should be remembered
    Given I am at step 2 of adding a determination
    When I select "Genus" from "level"
    And I fill in "term" with "banks"
    And I press "Search" within the main content
    Then the "term" field should contain "banks"
    And the "level" field should contain "genus"

  Scenario: search level should default to species
    Given I am at step 2 of adding a determination
    Then the "term" field should contain ""
    And the "level" field should contain "name"

  Scenario: search should allow partial matches
    Given I am at step 2 of adding a determination
    When I select "Species" from "level"
    And I fill in "term" with "foli"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order           | Family       | Subfamily | Tribe  | Genus       | Species      | Authority |        |
      | Div2     | Cls5  | Asteraceaeord   | Asteraceae   |           |        | Andryala    | integrifolia | F.Smith   | Select |
      | Div4     | Cls8  | Proteaceaeord   | Proteaceae   | Subf1     | Trb1   | Banksia     | integrifolia | Def       | Select |
      | Div4     | Cls8  | Rosaceaeord     | Rosaceae     | Subf2     | Tribe2 | Dryas       | integrifolia | Jkl       | Select |
      | Div4     | Cls7  | Hedwigiaceaeord | Hedwigiaceae |           |        | Hedwigia    | integrifolia | R.Br      | Select |
      | Div4     | Cls7  | Malvaceaeord    | Malvaceae    | Subf3     |        | Keraudrenia | integrifolia | Abc       | Select |
      | Div4     | Cls8  | Proteaceaeord   | Proteaceae   | Subf1     | Trb2   | Macadamia   | integrifolia | Ghi       | Select |

  Scenario: no search results
    Given I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with "blah"
    When I press "Search" within the main content
    Then I should see "No results were found for search 'blah'."
    When I press "Save"
  # I can still save without selecting something
    Then I should not see "Division"

  Scenario: searching but selecting nothing
    Given I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with "inte"
    When I press "Search" within the main content
    When I press "Save"
  # I can still save without selecting something
    Then I should not see "Division"

  Scenario: Search and select multiple times
    Given I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with "integrifolia"
    When I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order           | Family       | Subfamily | Tribe  | Genus       | Species      | Authority |        |
      | Div2     | Cls5  | Asteraceaeord   | Asteraceae   |           |        | Andryala    | integrifolia | F.Smith   | Select |
      | Div4     | Cls8  | Proteaceaeord   | Proteaceae   | Subf1     | Trb1   | Banksia     | integrifolia | Def       | Select |
      | Div4     | Cls8  | Rosaceaeord     | Rosaceae     | Subf2     | Tribe2 | Dryas       | integrifolia | Jkl       | Select |
      | Div4     | Cls7  | Hedwigiaceaeord | Hedwigiaceae |           |        | Hedwigia    | integrifolia | R.Br      | Select |
      | Div4     | Cls7  | Malvaceaeord    | Malvaceae    | Subf3     |        | Keraudrenia | integrifolia | Abc       | Select |
      | Div4     | Cls8  | Proteaceaeord   | Proteaceae   | Subf1     | Trb2   | Macadamia   | integrifolia | Ghi       | Select |
    When I select the first result in the species search results
    When I select "Family" from "level"
    And I fill in "term" with "Proteaceae"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order         | Family     |        |
      | Div4     | Cls8  | Proteaceaeord | Proteaceae | Select |
    When I select the first result in the species search results
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    But I should not see "Subfamily"
    But I should not see "Tribe"
    But I should not see "Genus"
    But I should not see "Species"

  Scenario: naturalised flag
    Given I am at step 2 of adding a determination
    When I select "Species" from "level"
    And I fill in "term" with "integrifolia"
    And I press "Search" within the main content
    When I select the first result in the species search results
    Then the "Naturalised" checkbox should not be checked
    When I check "Naturalised"
    And I press "Save"
    Then I should be on the specimen page
    And I should see field "Genus" with value "*Andryala"
    And I should see field "Species" with value "integrifolia"
    And the specimen title should include "*Andryala integrifolia"
    And I follow "View"
    And I should see field "Genus" with value "*Andryala"

  Scenario: should be able to see more than 50 results
    Given I have no species
    And I have 60 species starting with "spec"
    And I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with "spec"
    When I press "Search" within the main content
    And I should see "spec-01"
    And I should see "spec-50"
    And I should see "spec-51"
    And I should see "spec-59"

  Scenario: empty search
    Given I am at step 2 of adding a determination
    And I select "Species" from "level"
    And I fill in "term" with ""
    When I press "Search" within the main content
    Then I should see "Please enter a search term"

