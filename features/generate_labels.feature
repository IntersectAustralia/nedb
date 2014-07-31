Feature: Labels
  In order to track my physical specimens
  As a user
  I want to generate printable labels

  Background:
    Given I have specimen "specimen 1"
    And I have specimen "specimen 2"
    And I have herbaria
      | code  | name                          |
      | NSW   | NSW Botanical Gardens         |
      | WOLL  | University of Wollongong      |
      | SCU   | DNA Bank                      |
      | UNC   | University of Newcastle       |
      | Stud. | name: "UNE Student Herbarium  |
    And I have item types Silica Gel, Photo, Fruit, Specimen sheet, Bark, Pollen
    And "specimen 1" has an item of type "Specimen sheet"
    And I have the usual profiles and permissions
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I am logged in as "super@intersect.org.au"

  Scenario: Specimen with no determination
    Given I am on the specimen page for "specimen 1"
    When I follow "Print Labels"
    Then I should see "Labels cannot be generated for this specimen as it does not have a determination."
    And I should be on the specimen page for "specimen 1"

  Scenario: Specimen with no specimen sheets/fruits/replicates
    Given "specimen 2" has a determination with string "abc"
    And I am on the specimen page for "specimen 2"
    When I follow "Print Labels"
    Then I should see "There are no labels to generate for this specimen. Try adding some specimen sheets or fruit items."
    And I should be on the specimen page for "specimen 2"

  Scenario: Specimen with labels
    Given "specimen 1" has a determination with string "abc"
    Given I am on the specimen page for "specimen 1"
    When I follow "Print Labels"
    Then I should get a file with name "labels.pdf" and content type "application/pdf"

#  Tests for checking label details according to various scenarios as specified in each test below.
#  NOTE barcode still has to be manually checked in each test
#  further points to manually check for each test are specified in comments below
  Scenario: Correct labels are generated for a specimen: 1 label is generated for each item where the type has labels=true, plus 1 label for each replicate
    Given I have specimen "of a type of create_label True"
    And I have specimen "of 2 types of create_label True"
    And I have specimen "of types of create_label False"
    And I have specimen "with 3 Specimen sheets"
    And "of a type of create_label True" has an item of type "Specimen sheet"
    And "of a type of create_label True" has an item of type "Silica Gel"
    And "of 2 types of create_label True" has an item of type "Specimen sheet"
    And "of 2 types of create_label True" has an item of type "Fruit"
    And "of types of create_label False" has an item of type "Silica Gel"
    And "of types of create_label False" has an item of type "Photo"
    And "with 3 Specimen sheets" has an item of type "Specimen sheet"
    And "with 3 Specimen sheets" has an item of type "Specimen sheet"
    And "with 3 Specimen sheets" has an item of type "Specimen sheet"
    And "of a type of create_label True" has a determination with string "Determination abc"
    And "of 2 types of create_label True" has a determination with string "Determination def"
    And "of types of create_label False" has a determination with string "Determination ghi"
    And "with 3 Specimen sheets" has a determination with string "Determination jkl"
    And the specimen "of a type of create_label True" has replicates "WOLL,UNC"
    And the specimen "of 2 types of create_label True" has replicates "WOLL,UNC"
    And the specimen "of types of create_label False" has replicates "NSW,Stud."
    When I am on the specimen page for "with 3 Specimen sheets"
    And I follow "Print Labels"
    Then labels.pdf should contain string "Sheet 1 of 3"
    And labels.pdf should contain string "Sheet 2 of 3"
    And labels.pdf should contain string "Sheet 3 of 3"
    And accession number is displayed correctly for specimen "with 3 Specimen sheets"
    And collector and collection date are displayed correctly for specimen "with 3 Specimen sheets"
    And secondary collectors are displayed correctly for specimen "with 3 Specimen sheets"
    And determiners and determination date are displayed correctly for specimen "with 3 Specimen sheets"
    And replicates are displayed correctly for specimen "with 3 Specimen sheets"
    And I move the label of specimen "specimen with 3 Specimen Sheets" to directory "output"
  # manually check that Sheet 1 of 3 etc. appear on each label page for Specimen Sheet type for output/specimen with 3 Specimen Sheets_label.pdf
  # manually check that Specimen sheet does not appear as an Item on any page for output/specimen with 3 Specimen Sheets_label.pdf
    When I am on the specimen page for "of a type of create_label True"
    And I follow "Print Labels"
    Then labels.pdf should not contain string "Sheet 1 of"
    And accession number is displayed correctly for specimen "of a type of create_label True"
    And labels.pdf should contain string "Silica Gel."
    And collector and collection date are displayed correctly for specimen "of a type of create_label True"
    And secondary collectors are displayed correctly for specimen "of a type of create_label True"
    And determiners and determination date are displayed correctly for specimen "of a type of create_label True"
    And replicates are displayed correctly for specimen "of a type of create_label True"
    And I move the label of specimen "specimen with 1 type create_label True and 2 replicates" to directory "output"
  # manually check labels for other item types and replicates don't have Sheet numbering
    When I am on the specimen page for "of 2 types of create_label True"
    And I follow "Print Labels"
    And accession number is displayed correctly for specimen "of 2 types of create_label True"
    And labels.pdf should contain string "Fruit."
    And labels.pdf should not contain string "Fruit, Specimen sheet."
    And collector and collection date are displayed correctly for specimen "of 2 types of create_label True"
    And secondary collectors are displayed correctly for specimen "of 2 types of create_label True"
    And determiners and determination date are displayed correctly for specimen "of 2 types of create_label True"
    And replicates are displayed correctly for specimen "of 2 types of create_label True"
    And I move the label of specimen "specimen with 2 types create_label True and 2 replicates" to directory "output"
  # manually check the order the pages appear in: specimen sheets are first, then items of other types, then replicates (preceded by "ex")
    When I am on the specimen page for "of types of create_label False"
    And I follow "Print Labels"
    And accession number is displayed correctly for specimen "of types of create_label False"
    And labels.pdf should contain string "Photo, Silica Gel."
    And collector and collection date are displayed correctly for specimen "of types of create_label False"
    And secondary collectors are displayed correctly for specimen "of types of create_label False"
    And determiners and determination date are displayed correctly for specimen "of types of create_label False"
    And replicates are displayed correctly for specimen "of types of create_label False"
    And I move the label of specimen "specimen with types create_label False and 2 replicates with one student herbarium" to directory "output"
  # manually check that "ex" is shown before herbarium name for replicates that are not from the student herbarium

  Scenario: Specimens with only one "Specimen sheet" don't get sheet number labelling (no Sheet 1 of 1)
    Given I have specimen "with only one Specimen sheet"
    And "with only one Specimen sheet" has an item of type "Specimen sheet"
    And "with only one Specimen sheet" has a determination with string "A Determination"
    When I am on the specimen page for "with only one Specimen sheet"
    And I follow "Print Labels"
    Then labels.pdf should not contain string "Sheet 1 of 1"
    And accession number is displayed correctly for specimen "with only one Specimen sheet"
    And collector and collection date are displayed correctly for specimen "with only one Specimen sheet"
    And secondary collectors are displayed correctly for specimen "with only one Specimen sheet"
    And determiners and determination date are displayed correctly for specimen "with only one Specimen sheet"
    And replicates are displayed correctly for specimen "with only one Specimen sheet"
    And I move the label of specimen "specimen with only one Specimen sheet" to directory "output"

  Scenario: Works with specimen sheets but no other item types that have labels
    Given I have specimen "with specimen sheets and no other item types that have labels"
    And "with specimen sheets and no other item types that have labels" has an item of type "Specimen sheet"
    And "with specimen sheets and no other item types that have labels" has an item of type "Bark"
    And "with specimen sheets and no other item types that have labels" has an item of type "Pollen"
    And "with specimen sheets and no other item types that have labels" has a determination with string "A Determination"
    When I am on the specimen page for "with specimen sheets and no other item types that have labels"
    And I follow "Print Labels"
    Then labels.pdf should not contain string "Sheet 1"
    And labels.pdf should not contain string "Sheet 2"
    And labels.pdf should not contain string "Sheet 3"
    And accession number is displayed correctly for specimen "with specimen sheets and no other item types that have labels"
    And collector and collection date are displayed correctly for specimen "with specimen sheets and no other item types that have labels"
    And secondary collectors are displayed correctly for specimen "with specimen sheets and no other item types that have labels"
    And determiners and determination date are displayed correctly for specimen "with specimen sheets and no other item types that have labels"
    And replicates are displayed correctly for specimen "with specimen sheets and no other item types that have labels"
    And I move the label of specimen "with specimen sheets and no other item types that have labels" to directory "output"

  Scenario: Works with no specimen sheets but some other item types that have labels
    Given I have specimen "with other item types that have labels"
    And "with other item types that have labels" has an item of type "Fruit"
    And "with other item types that have labels" has an item of type "Fruit"
    And "with other item types that have labels" has an item of type "Fruit"
    And "with other item types that have labels" has a determination with string "Determination xyz"
    When I am on the specimen page for "with other item types that have labels"
    And I follow "Print Labels"
    Then labels.pdf should not contain string "Sheet 1"
    And labels.pdf should not contain string "Sheet 2"
    And labels.pdf should not contain string "Sheet 3"
    And accession number is displayed correctly for specimen "with other item types that have labels"
    And labels.pdf should contain string "Fruit."
    And labels.pdf should not contain string "Fruit, Fruit, Fruit."
    And collector and collection date are displayed correctly for specimen "with other item types that have labels"
    And secondary collectors are displayed correctly for specimen "with other item types that have labels"
    And determiners and determination date are displayed correctly for specimen "with other item types that have labels"
    And replicates are displayed correctly for specimen "with other item types that have labels"
    And I move the label of specimen "specimen with other item types that have labels" to directory "output"

  Scenario: Works with specimen sheets but no other item types that have labels
    Given I have specimen "with specimen sheets but no other item types that have labels"
    And "with specimen sheets but no other item types that have labels" has an item of type "Specimen sheet"
    And "with specimen sheets but no other item types that have labels" has an item of type "Specimen sheet"
    And "with specimen sheets but no other item types that have labels" has an item of type "Fruit"
    And "with specimen sheets but no other item types that have labels" has an item of type "Fruit"
    And "with specimen sheets but no other item types that have labels" has an item of type "Fruit"
    And "with specimen sheets but no other item types that have labels" has a determination with string "Determination 2S"
    When I am on the specimen page for "with specimen sheets but no other item types that have labels"
    And I follow "Print Labels"
    Then labels.pdf should contain string "Sheet 1 of 2"
    And labels.pdf should contain string "Sheet 2 of 2"
    And labels.pdf should not contain string "Sheet 1 of 3"
    And labels.pdf should not contain string "Sheet 2 of 3"
    And labels.pdf should not contain string "Sheet 3 of 3"
    And accession number is displayed correctly for specimen "with specimen sheets but no other item types that have labels"
    And labels.pdf should contain string "Fruit."
    And collector and collection date are displayed correctly for specimen "with specimen sheets but no other item types that have labels"
    And secondary collectors are displayed correctly for specimen "with specimen sheets but no other item types that have labels"
    And determiners and determination date are displayed correctly for specimen "with specimen sheets but no other item types that have labels"
    And replicates are displayed correctly for specimen "with specimen sheets but no other item types that have labels"
    And I move the label of specimen "specimen with specimen sheets but no other item type that have labels" to directory "output"

  Scenario: Display of scientific names (multiple scenarios)
    Given I have people
      | initials  | first_name | last_name |
      | G.R.      | Greg       | Adams     |
      | F.        | Fiona      | Wells     |
      | H.C.      | Henry      | Smith     |
    And I have specimen "check scientific names"
    And I have specimen "check scientific names no subspecies"
    And I have specimen "check scientific names no genus, subfamily, variety, or form"
    And the specimen "check scientific names" has determination:
      | division                  | Div4        |
      | class_name                | Cls8        |
      | order_name                | Rosaceaeord |
      | family                    | Rosaceae    |
      | sub_family                | Subfamily2  |
      | tribe                     | Tribe2      |
      | genus                     | Genus2      |
      | species                   | species2    |
      | species_authority         | SAuth2      |
      | sub_species               | subsp1      |
      | sub_species_authority     | ss1 auth    |
      | variety                   | var2        |
      | variety_authority         | v2 auth     |
      | form                      | form3       |
      | form_authority            | f3 auth     |
      | species_uncertainty       | \?          |
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
    And the specimen "check scientific names no subspecies" has determination:
      | division                  | Div9        |
      | class_name                | Class2      |
      | order_name                | Order name  |
      | family                    | Family name |
      | sub_family                | Subfamily   |
      | tribe                     | Tribe3      |
      | genus                     | Genus       |
      | species                   | species     |
      | species_authority         | species auth|
      | variety                   | variety     |
      | variety_authority         | v auth      |
      | form                      | form        |
      | form_authority            | f auth      |
      | species_uncertainty       | Y           |
      | variety_uncertainty       | vel. aff.   |
      | form_uncertainty          | aff.        |
      | family_uncertainty        |             |
      | sub_family_uncertainty    |             |
      | tribe_uncertainty         |             |
      | genus_uncertainty         |             |
      | determiner_herbarium_code | WOLL        |
      | determination_date_year   | 2012        |
      | determination_date_month  | 01          |
      | determination_date_day    | 30          |
      | determiner                | F. Wells    |
    And the specimen "check scientific names no genus, subfamily, variety, or form" has determination:
      | division                  | Div4        |
      | class_name                | Cls8        |
      | order_name                | Rosaceaeord |
      | family                    | Famsaceae   |
      | tribe                     | TribeZ      |
      | species                   | specie X    |
      | species_authority         | sp auth     |
      | sub_species               | subspeciesY |
      | sub_species_authority     | subsp auth  |
      | species_uncertainty       | \?          |
      | subspecies_uncertainty    | sens. lat.  |
      | family_uncertainty        |             |
      | tribe_uncertainty         |             |
      | determiner_herbarium_code | SCU         |
      | determination_date_year   | 2010        |
      | determination_date_month  | 06          |
      | determination_date_day    | 10          |
      | determiner                | G.R. Adams  |
    And "check scientific names" has an item of type "Fruit"
    And "check scientific names no subspecies" has an item of type "Specimen sheet"
    And "check scientific names no genus, subfamily, variety, or form" has an item of type "Specimen sheet"
    When I am on the specimen page for "check scientific names"
    And I follow "Print Labels"
#   auto checking scientific names displayed correctly for specimen "check scientific names"
    Then labels.pdf should contain:
    """
    Rosaceae subfam. Subfamily2

    Tribe2

    Genus2 species2 SAuth2
    subsp. subsp1 s. lat. ss1 auth
    var. var2 vel. aff. v2 auth
    f. aff. form3 f3 auth
    """
    And accession number is displayed correctly for specimen "check scientific names"
    And labels.pdf should contain string "Fruit."
    And collector and collection date are displayed correctly for specimen "check scientific names"
    And secondary collectors are displayed correctly for specimen "check scientific names"
    And determiners and determination date are displayed correctly for specimen "check scientific names"
    And replicates are displayed correctly for specimen "check scientific names"
    And I move the label of specimen "specimen check scientific names" to directory "output"
    When I am on the specimen page for "check scientific names no subspecies"
    And I follow "Print Labels"
    Then labels.pdf should contain:
    """
    Family name subfam. Subfamily

    Tribe3

    Genus species species auth
    var. variety vel. aff. v auth
    f. aff. form f auth
    """
    And I move the label of specimen "specimen check scientific names no subspecies" to directory "output"
    When I am on the specimen page for "check scientific names no genus, subfamily, variety, or form"
    And I follow "Print Labels"
    Then labels.pdf should contain:
    """
    Famsaceae

    TribeZ

    specie X sp auth
    subsp. subspeciesY s. lat. subsp auth
    """
    And I move the label of specimen "specimen check scientific names no genus, subfamily, variety, or form" to directory "output"

  Scenario: Correct header is shown (herbarium name, institution, address, notification text)
    Given I have specimen "check correct header"
    And "check correct header" has an item of type "Specimen sheet"
    And "check correct header" has an item of type "Specimen sheet"
    And "check correct header" has an item of type "Fruit"
    And "check correct header" has a determination with string "Det. abcd"
    And the specimen "check correct header" has replicates "WOLL,UNC,Stud."
    When I am on the specimen page for "check correct header"
    And I follow "Print Labels"
    Then labels.pdf should contain:
    """
    N\.C\.W\. Beadle Herbarium \(NE\)
    University of New England
    Armidale NSW 2351 Australia
    Notification of change of determination would be appreciated by NE
    """
    And labels.pdf should contain:
    """
    ex N\.C\.W\. Beadle Herbarium \(NE\)
    University of New England
    Armidale NSW 2351 Australia
    Notification of change of determination would be appreciated by NE
    """
    And accession number is displayed correctly for specimen "check correct header"
    And labels.pdf should contain string "Fruit."
    And replicates are displayed correctly for specimen "check correct header"
    And collector and collection date are displayed correctly for specimen "check correct header"
    And secondary collectors are displayed correctly for specimen "check correct header"
    And determiners and determination date are displayed correctly for specimen "check correct header"
    And I move the label of specimen "specimen check correct header" to directory "output"
#    manually check the values for each header field on each of the 6 labels are in the following order
# | herbarium name                  | institution               | address                     | notification text                                                  |
# | N.C.W. Beadle Herbarium (NE)    | University of New England | Armidale NSW 2351 Australia | Notification of change of determination would be appreciated by NE |
# | N.C.W. Beadle Herbarium (NE)    | University of New England | Armidale NSW 2351 Australia | Notification of change of determination would be appreciated by NE |
# | N.C.W. Beadle Herbarium (NE)    | University of New England | Armidale NSW 2351 Australia | Notification of change of determination would be appreciated by NE |
# | N.C.W. Beadle Herbarium (NE)    | University of New England | Armidale NSW 2351 Australia | Notification of change of determination would be appreciated by NE |
# | ex N.C.W. Beadle Herbarium (NE) | University of New England | Armidale NSW 2351 Australia | Notification of change of determination would be appreciated by NE |
# | ex N.C.W. Beadle Herbarium (NE) | University of New England | Armidale NSW 2351 Australia | Notification of change of determination would be appreciated by NE |

  Scenario: Display of country, state, botanical division, locality description from the specimen (non-mandatory values)
    Given I have countries
      | name         |
      | Australia    |
      | Peru         |
      | South Africa |
    And I have states
      | name            | country      |
      | New South Wales | Australia    |
      | Victoria        | Australia    |
      | Free State      | South Africa |
      | Western Cape    | South Africa |
    And I have botanical divisions
      | name | state           |
      | BD1  | New South Wales |
      | BD2  | New South Wales |
    And I have specimen "check locality description"
    And "check locality description" has a determination with string "Det. abcd"
    And "check locality description" has an item of type "Specimen sheet"
    When I am on the specimen page for "check locality description"
    And I follow "Print Labels"
    Then labels.pdf should contain string "AUSTRALIA: New South Wales: Central Tablelands: Royal National Park."
    And accession number is displayed correctly for specimen "check locality description"
    And collector and collection date are displayed correctly for specimen "check locality description"
    And secondary collectors are displayed correctly for specimen "check locality description"
    And determiners and determination date are displayed correctly for specimen "check locality description"
    And replicates are displayed correctly for specimen "check locality description"
    And I move the label of specimen "specimen check locality description" to directory "output"
    # manually check country is bold font in output/specimen check locality description_label.pdf
    Given I have specimens
      | tag              | country       | state       | botanical_division  | locality_description |
      | change locality  | South Africa  | Free State  | BD2                 | there and back again |
      | blank localities | Peru          |             | BD1                 |                      |
    And "change locality" has a determination with string "Det. def"
    And "change locality" has an item of type "Specimen sheet"
    When I am on the specimen page for "change locality"
    And I follow "Print Labels"
    Then labels.pdf should contain string "SOUTH AFRICA: Free State: BD2: there and back again."
    And accession number is displayed correctly for specimen "change locality"
    And I move the label of specimen "specimen change locality" to directory "output"
    # manually check country is bold font in output/specimen change locality_label.pdf
    And "blank localities" has a determination with string "Det. ghi"
    And "blank localities" has an item of type "Specimen sheet"
    When I am on the specimen page for "blank localities"
    And I follow "Print Labels"
    Then labels.pdf should contain string "PERU: BD1"
    And accession number is displayed correctly for specimen "blank localities"
    And I move the label of specimen "specimen blank localities" to directory "output"

  Scenario: Display of latitude/longitude, altitude/datum from the specimen (non-mandatory values)
    Given I have specimens
      | tag | latitude_degrees | latitude_minutes  | latitude_seconds | latitude_hemisphere | longitude_degrees | longitude_minutes | longitude_seconds | longitude_hemisphere | altitude | datum  |
      | check latitude longitude altitude datum | 34 | 6 | 0.021      | N                   | 87                | 3                 | 0.0034            | E                    | 2422     | WGS-84 |
      | check latitude no mins longitude no hem no altitude | 34 | |0.021 | N               | 87                | 3                 | 0.0034            |                      |          |WGS-84  |
    And "check latitude longitude altitude datum" has a determination with string "Det. jkl"
    And "check latitude longitude altitude datum" has an item of type "Specimen sheet"
    And "check latitude no mins longitude no hem no altitude" has a determination with string "Det. jkl"
    And "check latitude no mins longitude no hem no altitude" has an item of type "Specimen sheet"
    When I am on the specimen page for "check latitude longitude altitude datum"
    And I follow "Print Labels"
    Then labels.pdf should contain:
    """
    34° 6' 0.021" N 87° 3' 0.0034" E 2422 m WGS-84
    """
    And accession number is displayed correctly for specimen "check latitude longitude altitude datum"
    And collector and collection date are displayed correctly for specimen "check latitude longitude altitude datum"
    And secondary collectors are displayed correctly for specimen "check latitude longitude altitude datum"
    And determiners and determination date are displayed correctly for specimen "check latitude longitude altitude datum"
    And replicates are displayed correctly for specimen "check latitude longitude altitude datum"
    And I move the label of specimen "specimen check latitude longitude altitude datum" to directory "output"
    # manually check in "output/specimen check latitude longitude altitude datum_label.pdf" that lat/long are left aligned, altitude/datum are right aligned
    When I am on the specimen page for "check latitude no mins longitude no hem no altitude"
    And I follow "Print Labels"
    Then labels.pdf should contain:
    """
    34° 0.021" N 87° 3' 0.0034" WGS-84
    """
    And accession number is displayed correctly for specimen "check latitude no mins longitude no hem no altitude"
    And I move the label of specimen "specimen check latitude no mins longitude no hem no altitude" to directory "output"
    # manually check in "output/specimen check latitude no mins longitude no hem no altitude_label.pdf" that lat/long are left aligned, altitude/datum are right aligned

  Scenario: Display of topography, aspect, substrate and vegetation from the specimen (non-mandatory values)
    Given I have specimens
      | tag                                               | topography                                       | aspect | substrate              | vegetation   |
      | check topography aspect substrate vegetation      | Upper slope, almost level area of broad hill top | W      | Grey sand on sandstone | Acacia, Sprengelia, Epacris heath Cyperaceae herb |
      | check topography vegetation no aspect or substrate| Upper slope, almost level area of broad hill top |        |                        | Acacia, Sprengelia, Epacris heath Cyperaceae herb |
    And "check topography aspect substrate vegetation" has a determination with string "Det. mno"
    And "check topography aspect substrate vegetation" has an item of type "Specimen sheet"
    And "check topography vegetation no aspect or substrate" has a determination with string "Det. mno"
    And "check topography vegetation no aspect or substrate" has an item of type "Specimen sheet"
    And "check topography vegetation no aspect or substrate" has an item of type "Photo"
    When I am on the specimen page for "check topography aspect substrate vegetation"
    And I follow "Print Labels"
    Then labels.pdf should contain string "Upper slope, almost level area of broad hill top. W aspect. Grey sand on sandstone. Acacia, Sprengelia, Epacris heath Cyperaceae herb."
    And accession number is displayed correctly for specimen "check topography aspect substrate vegetation"
    And collector and collection date are displayed correctly for specimen "check topography aspect substrate vegetation"
    And secondary collectors are displayed correctly for specimen "check topography aspect substrate vegetation"
    And determiners and determination date are displayed correctly for specimen "check topography aspect substrate vegetation"
    And replicates are displayed correctly for specimen "check topography aspect substrate vegetation"
    And I move the label of specimen "specimen check topography aspect substrate vegetation" to directory "output"
    When I am on the specimen page for "check topography vegetation no aspect or substrate"
    And I follow "Print Labels"
    Then labels.pdf should contain string "Upper slope, almost level area of broad hill top. Acacia, Sprengelia, Epacris heath Cyperaceae herb."
    And accession number is displayed correctly for specimen "check topography vegetation no aspect or substrate"
    And labels.pdf should contain string "Photo."
    And I move the label of specimen "specimen check topography vegetation no aspect or substrate" to directory "output"

  Scenario: Display of frequency and plant description from the specimen (non-mandatory values)
    Given I have specimens
      | tag                                   | frequency  | plant_description                                   |
      | check frequency and plant description | Occasional | Rhizomatous, tussock perennial. Plants to c. 100 cm |
      | check plant description with no frequency |        | Rhizomatous, tussock perennial. Plants to c. 100 cm |
    And "check frequency and plant description" has a determination with string "Det. pqr"
    And "check plant description with no frequency" has a determination with string "Det. stu"
    And "check frequency and plant description" has an item of type "Specimen sheet"
    And "check frequency and plant description" has an item of type "Silica Gel"
    And "check frequency and plant description" has an item of type "Photo"
    And "check frequency and plant description" has an item of type "Fruit"
    And "check plant description with no frequency" has an item of type "Specimen sheet"
    And "check plant description with no frequency" has an item of type "Photo"
    When I am on the specimen page for "check frequency and plant description"
    And I follow "Print Labels"
    Then labels.pdf should contain string "Occasional. Rhizomatous, tussock perennial. Plants to c. 100 cm."
    And accession number is displayed correctly for specimen "check frequency and plant description"
    And labels.pdf should contain string "Fruit, Photo, Silica Gel."
    And collector and collection date are displayed correctly for specimen "check frequency and plant description"
    And secondary collectors are displayed correctly for specimen "check frequency and plant description"
    And determiners and determination date are displayed correctly for specimen "check frequency and plant description"
    And replicates are displayed correctly for specimen "check frequency and plant description"
    And I move the label of specimen "specimen check frequency and plant description" to directory "output"
    When I am on the specimen page for "check plant description with no frequency"
    And I follow "Print Labels"
    Then labels.pdf should contain string "Rhizomatous, tussock perennial. Plants to c. 100 cm."
    And accession number is displayed correctly for specimen "check plant description with no frequency"
    And labels.pdf should contain string "Photo."
    And collector and collection date are displayed correctly for specimen "check plant description with no frequency"
    And secondary collectors are displayed correctly for specimen "check plant description with no frequency"
    And determiners and determination date are displayed correctly for specimen "check plant description with no frequency"
    And replicates are displayed correctly for specimen "check plant description with no frequency"
    And I move the label of specimen "specimen check plant description with no frequency" to directory "output"
#    manually check determination date is right aligned in each output