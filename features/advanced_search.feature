Feature: Advanced Search
  In order to quickly find a specimen
  As an administrator
  I want to use an advanced search option

  Background:
    Given I have specimens
    | locality_description    | vegetation        | plant_description | replicate_from | topography   | aspect | substrate    | frequency     |
    | botanical gardens       | cactus            | spikey.           |                | desert-like  |   W    | yellow sand  |   rare        |
    | botany                  | gum tree          | approx. 15 m tall |   a            | outback      |   N    | grey sand    |   occasional  |
    |                         | tall gum, acacia  | yellow flowers    |                | out back     |   S    | dirt         |               |
    | kuringai national park  |                   |                   |                | outback      |   E    |              |   rare        |
    And I have the usual profiles and permissions
    And I have a user "super@intersect.org.au" with profile "Superuser"
    And I have a user "admin@intersect.org.au" with profile "Administrator"
    And I have a user "student@intersect.org.au" with profile "Student"


  Scenario: superuser can access advanced search page
    Given I am logged in as "super@intersect.org.au"
    And I am on the home page
    Then I should see link "Advanced Search" inside the nav bar
    And I follow "Advanced Search"
    Then I should be on the Advanced Search page

  Scenario: administrator can access advanced search page
    Given I am logged in as "admin@intersect.org.au"
    And I am on the home page
    Then I should see link "Advanced Search" inside the nav bar
    And I follow "Advanced Search"
    Then I should be on the Advanced Search page

  Scenario: student can access advanced search page
    Given I am logged in as "student@intersect.org.au"
    And I am on the home page
    Then I should see link "Advanced Search" inside the nav bar
    And I follow "Advanced Search"
    Then I should be on the Advanced Search page

  Scenario: Search without entering a search term returns all specimens
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I press "search_submit"
    Then the advanced search result table should contain
      | Locality               |
      | botanical gardens      |
      | botany                 |
      |                        |
      | kuringai national park |

  Scenario: Search which returns only one result
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_vegetation_contains" with "cactus"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality          | Vegetation  |
      | botanical gardens | cactus      |

  Scenario: Case-insensitive search
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_locality_description_contains" with "otan"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality          | Plant Description     |
      | botanical gardens | spikey.               |
      | botany            | approx. 15 m tall     |
    When I fill in "search_locality_description_contains" with "oTAn"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality          | Plant Description     |
      | botanical gardens | spikey.               |
      | botany            | approx. 15 m tall     |

  Scenario: Multiple fields are ANDed (to allow for narrowing of results)
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_locality_description_contains" with "bot"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality          | Plant Description     |
      | botanical gardens | spikey.               |
      | botany            | approx. 15 m tall     |
    When I fill in "search_plant_description_contains" with "spikey"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality          | Plant Description     |
      | botanical gardens | spikey.               |

  Scenario: A match occurs when the input value is contained entirely within table values
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_aspect_contains" with "N"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Aspect  |
      | N       |
    When I fill in "search_aspect_contains" with "NS"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Aspect  |

  Scenario: Search using all fields
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_locality_description_contains" with "botany"
    And I fill in "search_vegetation_contains" with "gum tree"
    And I fill in "search_plant_description_contains" with "approx. 15 m tall"
    And I fill in "search_replicate_from_contains" with "a"
    And I fill in "search_topography_contains" with "outback"
    And I fill in "search_aspect_contains" with "N"
    And I fill in "search_substrate_contains" with "grey sand"
    And I fill in "search_frequency_contains" with "occasional"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality                | Vegetation        | Plant Description | Replicate From | Topography   | Aspect | Substrate    | Frequency     |
      | botany                  | gum tree          | approx. 15 m tall |   a            | outback      |   N    | grey sand    |   occasional  |

  Scenario: Search for non-existent specimen
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_aspect_contains" with "abcdef"
    And I press "search_submit"
    Then the advanced search result table should contain
    | Locality   | Vegetation        | Plant Description | Replicate From | Topography   | Aspect | Substrate    | Frequency     |

  Scenario: Search for a country
    Given I have specimens
      | locality_description    | vegetation        | plant_description | country     | state           |
      | a sad plant             | blue plant        | sad               | Australia   | New South Wales |
      | a red plant             | red plant         | angry             | New Zealand |                 |
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_country_contains" with "New Zealand"
    And I press "search_submit"
    Then the advanced search result table should contain
    |  Country      | State    | Locality    |
    |  New Zealand  |          | a red plant |

  Scenario: Search for a country by partial name
    Given I have specimens
      | locality_description    | vegetation        | plant_description | country     | state           |
      | a sad plant             | blue plant        | sad               | Australia   | New South Wales |
      | a red plant             | red plant         | angry             | New Zealand |                 |
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_country_contains" with "new"
    And I press "search_submit"
    Then the advanced search result table should contain
      |  Country      | State    | Locality    |
      |  New Zealand  |          | a red plant |

  Scenario: Search for a state
    Given I have specimens
      | locality_description    | vegetation        | plant_description | country     | state           |
      | a sad plant             | blue plant        | sad               | Australia   | Victoria        |
      | a red plant             | red plant         | angry             | New Zealand |                 |
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_state_contains" with "victoria"
    And I press "search_submit"
    Then the advanced search result table should contain
      |  Country      | State    | Locality    |
      |  Australia    | Victoria | a sad plant |

  Scenario: Search for a botanical division
    Given I have specimens
    | locality_description    | vegetation        | plant_description | country     | state           | botanical_division |
    | a sad plant             | blue plant        | sad               | Australia   | Victoria        | Western Desert     |
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I fill in "search_botanical_division_contains" with "western desert"
    And I press "search_submit"
    Then the advanced search result table should contain
    |  Country      | State    | Locality    | Botanical Division |
    |  Australia    | Victoria | a sad plant | Western Desert     |

  Scenario: Search for items in specimen
    Given I have item types Silica Gel, Photo, Fruit, Plants
    Given I have specimen "Apples"
    And "Apples" has an item of type "Fruit"
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    When I check "Fruit"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Country      | State            | Botanical Division | Locality             |
      | Australia    | New South Wales  | Central Tablelands | Royal National Park  |

  Scenario: Searching for items which specimens have partials of
    Given I have item types Silica Gel, Photo, Fruit, Plants
    Given I have specimen "Apples"
    And "Apples" has an item of type "Fruit"
    And "Apples" has an item of type "Photo"
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    And I check "Fruit"
    And I check "Photo"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Country      | State            | Botanical Division | Locality             |
      | Australia    | New South Wales  | Central Tablelands | Royal National Park  |

  Scenario: Searching for specimens using Datum
    Given I have specimens
      | locality_description    | vegetation        | plant_description | country     | state           | botanical_division | datum    |
      | a datum plant           | silly plant       | i am datum        | Australia   | Victoria        | Western Desert     | ABC-123  |
    Given I am logged in as "super@intersect.org.au"
    And I am on the Advanced Search page
    And I fill in "search_datum_contains" with "ABC-123"
    And I press "search_submit"
    Then the advanced search result table should contain
      | Locality      | Vegetation    | Plant Description   |
      | a datum plant | silly plant   | i am datum          |