Feature: Edit Determination
  In order to
  As a user
  I want to

  Background:
    Given I have a specimen
    And I have people
      | initials  | first_name | last_name |
      | G.R.      | Greg       | Adams     |
      | F.        | Fiona      | Wells     |
      | H.C.      | Henry      | Smith     |
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
      | species_uncertainty       | ?           |
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


  Scenario: 'aff.' uncertainty
    Given I am on the specimen page
    Then I should see "Dryas ?abcd Mno"
    When I follow "Edit determination"
    And I press "Continue"
    And I check the determination_species_uncertainty checkbox with the value "aff."
    And I press "Save"
    Then I should see "Dryas aff. abcd Mno"

  Scenario: 'none'
    Given I am on the specimen page
    When I follow "Edit determination"
    And I press "Continue"
    And I check the determination_species_uncertainty checkbox with the value "none"
    And I press "Save"
    Then I should see "Dryas abcd Mno"

  Scenario: 'sens. strict.'
    Given I am on the specimen page
    When I follow "Edit determination"
    And I press "Continue"
    And I check the determination_species_uncertainty checkbox with the value "sens. strict."
    And I press "Save"
    Then I should see "Dryas abcd Mno s. str."

  Scenario: 'sens. lat.'
    Given I am on the specimen page
    When I follow "Edit determination"
    And I press "Continue"
    And I check the determination_species_uncertainty checkbox with the value "sens. lat."
    And I press "Save"
    Then I should see "Dryas abcd Mno s. lat."

  Scenario: 'vel. aff.'
    Given I am on the specimen page
    When I follow "Edit determination"
    And I press "Continue"
    And I check the determination_species_uncertainty checkbox with the value "vel. aff."
    And I press "Save"
    Then I should see "Dryas abcd Mno vel. aff."

  Scenario: '?'
    Given I am on the specimen page
    When I follow "Edit determination"
    And I press "Continue"
    And I check the determination_species_uncertainty checkbox with the value "?"
    And I press "Save"
    Then I should see "Dryas ?abcd Mno"