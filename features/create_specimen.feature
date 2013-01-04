@javascript
Feature: Create Specimens
  In order to track specimens
  As a user
  I want to create specimens
  
  Background:
    # Given I have no specimens
    Given I have specimens
    | locality_description    | vegetation        | plant_description | replicate_from | topography   | aspect | substrate    | frequency     |
    | botanical gardens       | cactus            | spikey.           |                | desert-like  |   W    | yellow sand  |   rare        |
    | botany                  | gum tree          | approx. 15 m tall |   a            | outback      |   N    | grey sand    |   occasional  |
    And I have people 
        | last_name     | initials  |
        | Adams         | G.R.      |
        | Wells         | A.P.      |
        | Smith         | V.N.      |
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

  Scenario: Countries dropdown should be populated and default to Australia
    Given I am on the home page
    When I follow "Add"
    Then the country dropdown should contain
        | name |
        | Australia   |
        | Algeria     |
        | Switzerland |
        | Peru        |
    And the "Country" field should contain "Australia"

  Scenario: Values from the first specimen are remembered when I create a second specimen
    Given I am on the home page
    And I follow "Add"
    And I select "G.R. Adams" from the collector select
    And I fill in "Collector number" with "12345"
    And I fill in "specimen_collection_date_day" with "25"
    And I fill in "specimen_collection_date_month" with "3"
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Australia" from the country select
    And I select "New South Wales" from the state select
    And I select "BD2" from the botanical division select
    And I fill in "Locality description" with "loc"
    And I fill in "specimen_latitude_degrees" with "1"
    And I fill in "specimen_latitude_minutes" with "2"
    And I fill in "specimen_latitude_seconds" with "3"
    And I select "N" from "specimen_latitude_hemisphere"
    And I fill in "specimen_longitude_degrees" with "4"
    And I fill in "specimen_longitude_minutes" with "5"
    And I fill in "specimen_longitude_seconds" with "6"
    And I select "W" from "specimen_longitude_hemisphere"
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
    When I follow "Add" within the nav bar
    #Then the "Collector" field should contain "G.R. Adams"
    And the "specimen_collection_date_day" field should contain "25"
    And the "specimen_collection_date_month" field should contain "3"
    And the "specimen_collection_date_year" field should contain "2010"
    And the "Country" field should contain "Australia"
    And the "State" field should contain "New South Wales"
    And the "Locality description" field should contain "loc"
    And the "specimen_latitude_degrees" field should contain "1"
    And the "specimen_latitude_minutes" field should contain "2"
    And the "specimen_latitude_seconds" field should contain "3"
    And the "specimen_latitude_hemisphere" field should contain "N"
    And the "specimen_longitude_degrees" field should contain "4"
    And the "specimen_longitude_minutes" field should contain "5"
    And the "specimen_longitude_seconds" field should contain "6"
    And the "specimen_longitude_hemisphere" field should contain "W"
    And the "Altitude" field should contain "100"
    #And the "Point data" field should contain "BD2"
    And the "Datum" field should contain "dat"
    And the "Topography" field should contain "topog"
    And the "Aspect" field should contain "asp"
    And the "Substrate" field should contain "sub"
    And the "Vegetation" field should contain "veg"

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
    And I follow "Set"
    And I fill in "specimen_id" with an available accession number
    And I select "G.R. Adams" from the collector select
    And I fill in "specimen_collection_date_year" with "2010"
    And I select "Please select" from the country select
    And I press "Create Specimen"
    # Doesn't verify that the accession number is in fact the one specified
    Then I should see "The specimen was successfully created."