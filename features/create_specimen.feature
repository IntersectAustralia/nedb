@javascript
Feature: Create Specimens
  In order to track specimens
  As a user
  I want to create specimens

  Background:
  # Given I have no specimens
    Given I have specimens
      | locality_description | vegetation | plant_description | replicate_from | topography  | aspect | substrate   | frequency  |
      | botanical gardens    | cactus     | spikey.           |                | desert-like | W      | yellow sand | rare       |
      | botany               | gum tree   | approx. 15 m tall | a              | outback     | N      | grey sand   | occasional |
    And I have people
      | last_name | initials |
      | Adams     | G.R.     |
      | Wells     | A.P.     |
      | Smith     | V.N.     |
    And I have countries
      | name         |
      | Algeria      |
      | Australia    |
      | Switzerland  |
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
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Create specimen with full details
    Given I am on the home page
    When I follow "Add"
    And I select "G.R. Adams" from the collector select
    And I fill in "Collector number" with "12345"
    And I fill in "specimen_collection_date_day" with "25"
    And I fill in "specimen_collection_date_month" with "3"
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Australia" from the country select
    And I select "New South Wales" from the state select
    And I select "BD2" from the botanical division select
    And I fill in "Locality description" with "loc"
    And I fill in "Altitude" with "100"
    And I choose "specimen_point_data_gps"
    And I fill in "Datum" with "dat"
    And I fill in "Topography" with "topog"
    And I fill in "Aspect" with "asp"
    And I fill in "Substrate" with "sub"
    And I fill in "Vegetation" with "veg"
    And I fill in "Frequency" with "freq"
    And I fill in "Plant description" with "desc"

    And I press "Create Specimen"
    Then I should see "The specimen was successfully created."
  # These could be improved
    And I should see field "Collector" with value "G.R. Adams"
    And I should see field "Collector number" with value "123"
    And I should see field "Collection date" with value "25 Mar. 2010"
    And I should have 3 specimen

  Scenario: Create specimen with minimal details
    Given I am on the home page
    When I follow "Add"
    And I select "G.R. Adams" from the collector select
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Please select" from the country select
    And I press "Create Specimen"
    Then I should see "The specimen was successfully created."

  Scenario: Create specimen without minimum details entered
    Given I am on the home page
    When I follow "Add"
    And I select "Please select" from the country select
    And I press "Create Specimen"
    Then I should see "2 errors need to be corrected before this record can be saved."
    And I should see "Collector can't be blank"
    And I should see "Enter a year for Collection date"

  Scenario: Create specimen with random text as accession number
    Given I am on the home page
    When I follow "Add"
    And I select "G.R. Adams" from the collector select
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Please select" from the country select
    And I follow "Set"
    And I fill in "Accession number" with "text"
    And I press "Create Specimen"
    Then I should see "1 error need to be corrected before this record can be saved."
    And I should see "Accession number needs to be greater than 0"

  Scenario: Countries dropdown should be populated and default to Australia
    Given I am on the home page
    When I follow "Add"
    Then the country dropdown should contain
      | name        |
      | Australia   |
      | Algeria     |
      | Switzerland |
      | Peru        |
    And the "Country" field should contain "Australia"

  Scenario: Values from the first specimen are remembered when I create a second specimen
    When I add a new specimen
    And I attempt to create a second specimen
    Then the values of the first specimen are remembered

  Scenario: Supply an accession number that's out of range
    Given I am on the home page
    When I follow "Add"
    And I follow "Set"
    And I fill in "specimen_id" with an accession number that's out of range
    And I select "G.R. Adams" from the collector select
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Please select" from the country select
    And I press "Create Specimen"
    Then I should see "Supplied accession number"
    And I should see "is out of range"

  Scenario: Supply an accession number that's less than zero
    Given I am on the home page
    When I follow "Add"
    And I follow "Set"
    And I fill in "specimen_id" with "-20"
    And I select "G.R. Adams" from the collector select
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Please select" from the country select
    And I press "Create Specimen"
    Then I should see "Accession number needs to be greater than 0"

  Scenario: Supply an accession number that's already in use
    Given I am on the home page
    When I follow "Add"
    And I follow "Set"
    And I fill in "specimen_id" with an existing accession number
    And I select "G.R. Adams" from the collector select
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Please select" from the country select
    And I press "Create Specimen"
    Then I should see "Supplied accession number"
    And I should see "already in use"

  Scenario: Supply a valid accession
    Given I am on the home page
    When I follow "Add"
    And I wait for a while
    And I follow "Set"
    And I fill in "specimen_id" with an available accession number
    And I select "G.R. Adams" from the collector select
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Please select" from the country select
    And I press "Create Specimen"
  # Doesn't verify that the accession number is in fact the one specified
    Then I should see "The specimen was successfully created."

  Scenario: Accession number field does not appear on edit
    Given I have a specimen
    And I am on the specimen page
    And I follow "Edit Specimen Details"
    And I should not see "Accession number"
    And I should not see "Autogenerate"