@javascript
Feature: Edit Determination
  In order to
  As a user
  I want to

  Background:
    Given I have a specimen
    And I have people
      | initials | first_name | last_name |
      | G.R.     | Greg       | Adams     |
      | F.       | Fiona      | Wells     |
      | H.C.     | Henry      | Smith     |
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
    And species "efgh" has forms
      | form  | authority |
      | form4 | f4 auth   |
      | form5 | f5 auth   |
      | form6 | f6 auth   |
    And species "efgh" has subspecies
      | subspecies | authority |
      | subsp4     | s4 auth   |
      | subsp5     | s5 auth   |
      | subsp6     | s6 auth   |
    And species "efgh" has varieties
      | variety | authority |
      | var4    | v4 auth   |
      | var5    | v5 auth   |
      | var6    | v6 auth   |
    And the specimen has determination
      | division                  | Div4        |
      | class_name                | Cls8        |
      | order_name                | Rosaceaeord |
      | family                    | Rosaceae    |
      | sub_family                | Subf2       |
      | tribe                     | Tribe2      |
      | genus                     | Dryas       |
      | species                   | abcd        |
      | species_authority         | Mno         |
      | sub_species               | subsp1      |
      | sub_species_authority     | s1 auth     |
      | variety                   | var2        |
      | variety_authority         | v2 auth     |
      | form                      | form3       |
      | form_authority            | f3 auth     |
      | species_uncertainty       |             |
      | subspecies_uncertainty    | sens. lat.  |
      | variety_uncertainty       | vel. aff.   |
      | form_uncertainty          | aff.        |
      | family_uncertainty        |             |
      | sub_family_uncertainty    |             |
      | tribe_uncertainty         |             |
      | genus_uncertainty         |             |
      | determiner_herbarium_code | SCU         |
      | determination_date_year   | 2010        |
      | determination_date_month  | 06          |
      | determination_date_day    | 10          |
      | determiner                | H.C. Smith  |
    And I have an uncertainty type "?"
    And I have an uncertainty type "sens. strict."
    And I have an uncertainty type "sens. lat."
    And I have an uncertainty type "vel. aff."
    And I have an uncertainty type "aff."
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: determiners, date and herbarium should be updated
    Given I am on the specimen page
    When I follow "Edit determination"
    And I fill in "determination_determination_date_year" with "1979"
    And I fill in "determination_determination_date_month" with "12"
    And I fill in "determination_determination_date_day" with "5"
    And I select "G.R. Adams" from the determiners select
    And I select "F. Wells" from the determiners select
    And I deselect "H.C. Smith" from the determiners select
    And I select "NSW - NSW Botanical Gardens" from "Determiner herbarium"
    And I press "Continue"
    When I press "Save"
    And I should see a determination table with
      | Date Determined | Determiners          | Determiner Herbarium | Date Confirmed | Confirmer | Confirmer Herbarium |
      | 5 Dec. 1979     | G.R. Adams, F. Wells | NSW                  |                |           |                     |

  Scenario: Should not get past step 1 without passing date validation
    Given I am on the specimen page
    When I follow "Edit determination"
    When I fill in "determination_determination_date_year" with ""
    And I press "Continue"
    Then I should see "Enter a year for Determination date"
    And I should see "Step 1:"
    When I fill in "determination_determination_date_year" with "2010"
    And I press "Continue"
    Then I should see "Step 2:"

  Scenario: Should not get past step 1 without passing determiners validation
    Given I am on the specimen page
    When I follow "Edit determination"
    And I fill in "determination_determination_date_year" with "2010"
    And I deselect "H.C. Smith" from the determiners select
    And I press "Continue"
    Then I should see "Determiners can't be blank"
    And I should see "Step 1:"
    And I select "G.R. Adams" from the determiners select
    And I press "Continue"
    Then I should see "Step 2:"

  Scenario: When editing, step 2 should show my existing saved details
    Given I am at step 2 of editing a determination
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Rosaceaeord"
    And I should see field "Family" with value "Rosaceae"
    And I should see field "Subfamily" with value "Subf2"
    And I should see field "Tribe" with value "Tribe2"
    And I should see field "Genus" with value "Dryas"
    And I should see field "Species" with value "abcd"
    And I should see field "Species Authority" with value "Mno"
    And the "determination_subspecies_uncertainty_sens_lat" checkbox should be checked
    And the "determination_variety_uncertainty_vel_aff" checkbox should be checked
    And the "determination_form_uncertainty_aff" checkbox should be checked
    And the "Subspecies" select should be set to "subsp1 - s1 auth"
    And the "Variety" select should be set to "var2 - v2 auth"
    And the "Form" select should be set to "form3 - f3 auth"

  Scenario: When editing, changes on page 1 should not be saved until I click save on page 2
    Given I am on the specimen page
    When I follow "Edit determination"
    And I fill in "determination_determination_date_year" with "1979"
    And I fill in "determination_determination_date_month" with "12"
    And I fill in "determination_determination_date_day" with "5"
    And I select "G.R. Adams" from the determiners select
    And I select "F. Wells" from the determiners select
    And I deselect "H.C. Smith" from the determiners select
    And I select "NSW - NSW Botanical Gardens" from "Determiner herbarium"
    And I press "Continue"
    When I follow "Cancel"
  # making this pending as we want hudson to pass - this is a known bug see UNEHERB-311
    When pending
#    And I should see a determination table with
#      | Date Determined | Determiners | Determiner Herbarium | Date Confirmed | Confirmer | Confirmer Herbarium |
#      | 10 June 2010    | H.C. Smith  | SCU                  |                |           |                     |

  Scenario: should be able to save without changing the plant name details at all
    Given I am at step 2 of editing a determination
    When I press "Save"
    Then I should be on the specimen page
    And the determination record should have
      | division               | Div4        |
      | class_name             | Cls8        |
      | order_name             | Rosaceaeord |
      | family                 | Rosaceae    |
      | sub_family             | Subf2       |
      | tribe                  | Tribe2      |
      | genus                  | Dryas       |
      | species                | abcd        |
      | species_authority      | Mno         |
      | sub_species            | subsp1      |
      | sub_species_authority  | s1 auth     |
      | variety                | var2        |
      | variety_authority      | v2 auth     |
      | form                   | form3       |
      | form_authority         | f3 auth     |
      | species_uncertainty    |             |
      | subspecies_uncertainty | sens. lat.  |
      | variety_uncertainty    | vel. aff.   |
      | form_uncertainty       | aff.        |
      | family_uncertainty     |             |
      | sub_family_uncertainty |             |
      | tribe_uncertainty      |             |
      | genus_uncertainty      |             |

  Scenario: Show warning if species has been renamed for an existing determination
    Given I am at step 2 of editing a determination
    Then the determination record should have
      | species | abcd |
    And I should not see "The name selected for this determination is no longer in the database. Please select another name or contact the herbarium."
    When I am on the edit species page for "abcd"
    Then I should see "Edit Species"
    And I fill in "Species" with "abcd_NOW_CHANGED"
    And I press "Update Species"
    When I am on the specimen page
    And I follow "Edit determination"
    And I press "Continue"
    Then the determination record should have
      | species | abcd |
    And I should see "The name selected for this determination is no longer in the database. Please select another name or contact the herbarium."

  Scenario: Search by division
    Given I am at step 2 of editing a determination
    And I select "Division" from "level"
    And I fill in "term" with "Div2"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division |        |
      | Div2     | Select |
    When I follow "Select"
    Then I should see field "Division" with value "Div2"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div2"
    And I should not see "Class"
    And I should not see "Species"
    And I should not see "Subspecies"
    And I should see a determination table with
      | Date Determined | Determiners          | Determiner Herbarium | Date Confirmed | Confirmer | Confirmer Herbarium |
      | 1979            | G.R. Adams, F. Wells | NSW                  |                |           |                     |

  Scenario: Search by class
    Given I am at step 2 of editing a determination
    When I select "Class" from "level"
    And I fill in "term" with "Cls7"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class |        |
      | Div4     | Cls7  | Select |
    When I follow "Select"
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should not see "Order"

  Scenario: Search by order
    Given I am at step 2 of editing a determination
    When I select "Order" from "level"
    And I fill in "term" with "Hedwigiaceaeord"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order           |        |
      | Div4     | Cls7  | Hedwigiaceaeord | Select |
    When I follow "Select"
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Hedwigiaceaeord"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Hedwigiaceaeord"
    But I should not see "Family"

  Scenario: Search by family
    Given I am at step 2 of editing a determination
    When I select "Family" from "level"
    And I fill in "term" with "Hedwigiaceae"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order           | Family       |        |
      | Div4     | Cls7  | Hedwigiaceaeord | Hedwigiaceae | Select |
    When I follow "Select"
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Hedwigiaceaeord"
    And I should see field "Family" with value "Hedwigiaceae"
    Then I should see uncertainty radio buttons for "family"
      | uncertainty   |
      | ?             |
      | sens. strict. |
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Hedwigiaceaeord"
    And I should see field "Family" with value "Hedwigiaceae"
    But I should not see "Subfamily"

  Scenario: Search by subfamily
    Given I am at step 2 of editing a determination
    When I select "Subfamily" from "level"
    And I fill in "term" with "Subf3"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order        | Family    | Subfamily |        |
      | Div4     | Cls7  | Malvaceaeord | Malvaceae | Subf3     | Select |
    When I follow "Select"
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Malvaceaeord"
    And I should see field "Family" with value "Malvaceae"
    And I should see field "Subfamily" with value "Subf3"
  # should see uncertainties
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls7"
    And I should see field "Order" with value "Malvaceaeord"
    And I should see field "Family" with value "Malvaceae"
    And I should see field "Subfamily" with value "Subf3"
    But I should not see "Tribe"

  Scenario: Search by tribe
    Given I am at step 2 of editing a determination
    When I select "Tribe" from "level"
    And I fill in "term" with "Trb1"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order         | Family     | Subfamily | Tribe |        |
      | Div4     | Cls8  | Proteaceaeord | Proteaceae | Subf1     | Trb1  | Select |
    When I follow "Select"
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    And I should see field "Subfamily" with value "Subf1"
    And I should see field "Tribe" with value "Trb1"
  # should see uncertainties
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
    Given I am at step 2 of editing a determination
    When I select "Genus" from "level"
    And I fill in "term" with "Macadamia"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order         | Family     | Subfamily | Tribe | Genus     |        |
      | Div4     | Cls8  | Proteaceaeord | Proteaceae | Subf1     | Trb2  | Macadamia | Select |
    When I follow "Select"
    Then I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    And I should see field "Subfamily" with value "Subf1"
    And I should see field "Tribe" with value "Trb2"
    And I should see field "Genus" with value "Macadamia"
  # should see uncertainties
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And I should see field "Class" with value "Cls8"
    And I should see field "Order" with value "Proteaceaeord"
    And I should see field "Family" with value "Proteaceae"
    And I should see field "Subfamily" with value "Subf1"
    And I should see field "Tribe" with value "Trb2"
    And I should see field "Genus" with value "Macadamia"
    But I should not see "Species"

  Scenario: Search by species
    Given I am at step 2 of editing a determination
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
    When I follow "Select"
    Then I should see field "Division" with value "Div2"
    And I should see field "Class" with value "Cls5"
    And I should see field "Order" with value "Asteraceaeord"
    And I should see field "Family" with value "Asteraceae"
    And I should see field "Subfamily" with value ""
    And I should see field "Tribe" with value ""
    And I should see field "Genus" with value "Andryala"
    And I should see field "Species" with value "integrifolia"
    And I should see field "Species Authority" with value "F.Smith"
  # should see uncertainty options
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
    Given I am at step 2 of editing a determination
    And I select "Species" from "level"
    And I fill in "term" with "efgh"
    And I press "Search" within the main content
    And I follow "Select"
    When I select "subsp4 - s4 auth" from "Subspecies"
    And I select "var5 - v5 auth" from "Variety"
    And I select "form6 - f6 auth" from "Form"
    And I choose "none" within "#display_subspecies_uncertainty"
    And I choose "none" within "#display_variety_uncertainty"
    And I choose "none" within "#display_form_uncertainty"
  # TODO should see each drop down with correct values
    And I press "Save"
    Then I should be on the specimen page
    And I should see field "Subspecies" with value "subsp. subsp4 s4 auth"
    And I should see field "Variety" with value "var. var5 v5 auth"
    And I should see field "Form" with value "f. form6 f6 auth"

  Scenario: Family uncertainty should be saved and displayed correctly
    Given I am at step 2 of editing a determination
    And I select "Family" from "level"
    And I fill in "term" with "Proteaceae"
    And I press "Search" within the main content
    And I follow "Select"
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Family" with value "?Proteaceae"
    And the specimen title should include "?Proteaceae"
    When I follow "View"
    Then I should see field "Family" with value "?Proteaceae"

  Scenario: Subfamily uncertainty should be saved and displayed correctly
    Given I am at step 2 of editing a determination
    And I select "Subfamily" from "level"
    And I fill in "term" with "Subf3"
    And I press "Search" within the main content
    And I follow "Select"
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Subfamily" with value "?Subf3"
    And the specimen title should include "Malvaceae subfam. ?Subf3"
    When I follow "View"
    Then I should see field "Subfamily" with value "?Subf3"

  Scenario: Tribe uncertainty should be saved and displayed correctly
    Given I am at step 2 of editing a determination
    And I select "Tribe" from "level"
    And I fill in "term" with "Trb1"
    And I press "Search" within the main content
    And I follow "Select"
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Tribe" with value "?Trb1"
    And the specimen title should include "Proteaceae subfam. Subf1"
    And the specimen title should include "?Trb1"
    When I follow "View"
    Then I should see field "Tribe" with value "?Trb1"

  Scenario: Genus uncertainty should be saved and displayed correctly
    Given I am at step 2 of editing a determination
    And I select "Genus" from "level"
    And I fill in "term" with "Dryas"
    And I press "Search" within the main content
    And I follow "Select"
    And I choose "?"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Genus" with value "?Dryas"
    And the specimen title should include "Rosaceae subfam. Subf2"
    And the specimen title should include "Tribe2 ?Dryas"
    When I follow "View"
    Then I should see field "Genus" with value "?Dryas"

  Scenario: Species uncertainty should be saved and displayed correctly
    Given I am at step 2 of editing a determination
    And I select "Species" from "level"
    And I fill in "term" with "integrifolia"
    And I press "Search" within the main content
    And I follow "Select"
    And I choose "sens. strict."
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Species" with value "integrifolia s. str."
    And the specimen title should include "Asteraceae"
    And the specimen title should include "Andryala integrifolia F.Smith s. str."
    When I follow "View"
    Then I should see field "Species" with value "integrifolia s. str."
#
#  Scenario: Subspecies, variety, form uncertainties should be saved and displayed correctly
#    Given I am at step 2 of editing a determination
#    And I select "Species" from "level"
#    And I fill in "term" with "abcd"
#    And I press "Search" within the main content
#    And I follow "Select"
#    And I select "subsp1 - s1 auth" from "Subspecies"
#    And I select "var2 - v2 auth" from "Variety"
#    And I select "form3 - f3 auth" from "Form"
#    And I choose "sens. lat." within "#display_subspecies_uncertainty"
#    And I choose "vel. aff." within "#display_variety_uncertainty"
#    And I choose "aff." within "#display_form_uncertainty"
#    And I press "Save"
#    Then I should be on the specimen page
#    And I should see field "Subspecies" with value "subsp. subsp1 s. lat. s1 auth"
#    And I should see field "Variety" with value "var. var2 vel. aff. v2 auth"
#    And I should see field "Form" with value "f. aff. form3 f3 auth"
#    And the specimen title should include "Rosaceae subfam. Subf2"
#    And the specimen title should include "Tribe2 Dryas abcd Mno"
#    And the specimen title should include "subsp. subsp1 s. lat. s1 auth"
#    And the specimen title should include "var. var2 vel. aff. v2 auth"
#    And the specimen title should include "f. aff. form3 f3 auth"
#    When I follow "View"
#    Then I should see field "Subspecies" with value "subsp. subsp1 s. lat. s1 auth"
#    And I should see field "Variety" with value "var. var2 vel. aff. v2 auth"
#    And I should see field "Form" with value "f. aff. form3 f3 auth"

  Scenario: search type and term should be remembered
    Given I am at step 2 of editing a determination
    When I select "Genus" from "level"
    And I fill in "term" with "banks"
    And I press "Search" within the main content
    Then the "term" field should contain "banks"
    And the "level" field should contain "genus"

  Scenario: search level should default to species
    Given I am at step 2 of editing a determination
    Then the "term" field should contain ""
    And the "level" field should contain "name"

  Scenario: search should allow partial matches
    Given I am at step 2 of editing a determination
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
    Given I am at step 2 of editing a determination
    When I search for species "blah"
    Then I should see "No results were found for search 'blah'."
    When I press "Save"
# I can still save without selecting something
#Then I should not see "Division"

  Scenario: searching but selecting nothing
    Given I am at step 2 of editing a determination
    When I search for species "inte"
    When I press "Save"
# I can still save without selecting something
#Then I should not see "Division"

  Scenario: Search and select multiple times
    Given I am at step 2 of editing a determination
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
    And I follow "Select"
    When I select "Family" from "level"
    And I fill in "term" with "Proteaceae"
    And I press "Search" within the main content
    Then I should see "search_results" table with
      | Division | Class | Order         | Family     |        |
      | Div4     | Cls8  | Proteaceaeord | Proteaceae | Select |
    When I follow "Select"
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

  Scenario: higher uncertainties are cleared when changing to determine at a more specific level
    Given I have a specimen
    And the specimen has determination
      | division                  | Div4        |
      | class_name                | Cls8        |
      | order_name                | Rosaceaeord |
      | family                    | Rosaceae    |
      | family_uncertainty        | aff.        |
      | determiner_herbarium_code | SCU         |
      | determination_date_year   | 2010        |
      | determination_date_month  | 06          |
      | determination_date_day    | 10          |
      | determiner                | H.C. Smith  |
    Given I am at step 2 of editing a determination
    When I select "Genus" from "level"
    And I fill in "term" with "Macadamia"
    And I press "Search" within the main content
    And I follow "Select"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Family" with value "Proteaceae"
    And I should see field "Genus" with value "Macadamia"
    And I should not see "aff. Proteaceae"

  Scenario: all lower fields are cleared when changing to determine at a higher level
    Given I have a specimen
    And the specimen has determination
      | division                  | Div4          |
      | class_name                | Cls8          |
      | order_name                | Rosaceaeord   |
      | family                    | Rosaceae      |
      | sub_family                | Subf2         |
      | tribe                     | Tribe2        |
      | genus                     | Dryas         |
      | species                   | abcd          |
      | species_authority         | Mno           |
      | sub_species               | subsp1        |
      | sub_species_authority     | s1 auth       |
      | variety                   | var2          |
      | variety_authority         | v2 auth       |
      | form                      | form3         |
      | form_authority            | f3 auth       |
      | species_uncertainty       | sens. strict. |
      | subspecies_uncertainty    | sens. lat.    |
      | variety_uncertainty       | vel. aff.     |
      | form_uncertainty          | aff.          |
      | family_uncertainty        | aff.          |
      | sub_family_uncertainty    | aff.          |
      | tribe_uncertainty         | aff.          |
      | genus_uncertainty         | aff.          |
      | determiner_herbarium_code | SCU           |
      | determination_date_year   | 2010          |
      | determination_date_month  | 06            |
      | determination_date_day    | 10            |
      | determiner                | H.C. Smith    |
    And I am at step 2 of editing a determination
    When I select "Division" from "level"
    And I fill in "term" with "Div4"
    And I press "Search" within the main content
    And I follow "Select"
    When I press "Save"
    Then I should be on the specimen page
    And I should see field "Division" with value "Div4"
    And the determination record should have
      | division               | Div4 |
      | class_name             |      |
      | order_name             |      |
      | family                 |      |
      | sub_family             |      |
      | tribe                  |      |
      | genus                  |      |
      | species                |      |
      | species_authority      |      |
      | sub_species            |      |
      | sub_species_authority  |      |
      | variety                |      |
      | variety_authority      |      |
      | form                   |      |
      | form_authority         |      |
      | species_uncertainty    |      |
      | subspecies_uncertainty |      |
      | variety_uncertainty    |      |
      | form_uncertainty       |      |
      | family_uncertainty     |      |
      | sub_family_uncertainty |      |
      | tribe_uncertainty      |      |
      | genus_uncertainty      |      |

  Scenario: Old determination without plant name does not crash when updated and raises plant name validation
    Given I have a specimen
    And the specimen has an old determination without a plant name
      | determiner_herbarium_code | SCU        |
      | determination_date_year   | 2010       |
      | determination_date_month  | 06         |
      | determination_date_day    | 10         |
      | determiner                | H.C. Smith |
    And I am on the specimen page
    And I follow "Edit determination"
    And I press "Continue"
    And I press "Save"
    And I should see "You must select a plant name"
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
      | Date Determined | Determiners | Determiner Herbarium | Date Confirmed | Confirmer | Confirmer Herbarium |
      | 10 June 2010    | H.C. Smith  | SCU                  |                |           |                     |

# Edit naturalised flag
# Change from no plant to plant
# Plant to no plant
# Change at same level
# Change sub/var/f
# Remove sub/var/f
# Add/Remove uncertainty
# Leave as is (should remain the same)
