Feature: Advanced Search
  In order to quickly find a specimen
  As an administrator
  I want to use an advanced search option

  Background:
    Given I have the usual seeded data
    And I have the advanced search test specimens
    And I have the usual profiles and permissions
    And I have a user "student@intersect.org.au" with profile "Student"
    Given I am logged in as "student@intersect.org.au"
    And I am on the Advanced Search page

  Scenario: Empty search
    And I press "search_submit"
    And I should see "Showing all 12 specimens"
    Then I should see specimens "1,2,3,4,5,6,7,8,9,10,11,12"

  Scenario Outline: Search by created date
    When I fill in "search_created_at_from_day" with "<day>"
    When I fill in "search_created_at_from_month" with "<month>"
    When I fill in "search_created_at_from_year" with "<year>"
    When I fill in "search_created_at_to_day" with "<day_to>"
    When I fill in "search_created_at_to_month" with "<month_to>"
    When I fill in "search_created_at_to_year" with "<year_to>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | year | month | day | year_to | month_to | day_to | message                     | results                    |
    | 2014 |       |     |         |          |        | No specimen was found.      |                            |
    | 2012 |       |     |         |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 2013 |       |     |         |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 2013 | 11    |     |         |          |        | Found 2 matching specimens  | 11,12                      |
    | 2013 | 11    | 01  |         |          |        | Found 2 matching specimens  | 11,12                      |
    | 2013 | 11    | 02  |         |          |        | Found 1 matching specimens  | 12                         |
    |      |       |     | 2013    | 11       | 01     | Found 11 matching specimens | 1,2,3,4,5,6,7,8,9,10,11    |
    |      |       |     | 2013    | 10       | 30     | Found 10 matching specimens | 1,2,3,4,5,6,7,8,9,10       |
    |      |       |     | 2013    |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |      |       |     | 2014    |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |      |       |     | 2012    |          |        | No specimen was found.      |                            |
    | 2013 | 05    | 02  | 2013    | 07       | 01     | Found 2 matching specimens  | 6,7                        |

  Scenario Outline: Search by locality
    When I fill in "Locality" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example     | message                     | results                    |
    | asdf        | No specimen was found.      |                            |
    | local       | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | ocal        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | locality_1  | Found 4 matching specimens  | 1,10,11,12                 |
    | locality_12 | Found 1 matching specimens  | 12                         |

  Scenario Outline: Search by vegetation
    When I fill in "Vegetation" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example       | message                     | results                    |
    | asdf          | No specimen was found.      |                            |
    | ation_        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | veg           | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | vegetation_1  | Found 4 matching specimens  | 1,2,3,12                   |
    | vegetation_12 | Found 1 matching specimens  | 1                          |

  Scenario Outline: Search by plant description
    When I fill in "Plant description" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example  | message                     | results                    |
    | asdf     | No specimen was found.      |                            |
    | plant_12 | No specimen was found.      |                            |
    | pla      | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | ant_     | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | plant_2  | Found 5 matching specimens  | 8,9,10,11,12               |
    | plant_20 | Found 1 matching specimens  | 8                          |

  Scenario Outline: Search by replicate from
    When I fill in "Replicate from" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                    | results |
    | asdf    | No specimen was found.     |         |
    | on      | Found 2 matching specimens | 1,6     |
    | derider | Found 2 matching specimens | 8,9     |
    | lighter | Found 1 matching specimens | 12      |

  Scenario Outline: Search by replicate from number
    When I fill in "Replicate from number" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                    | results  |
    | asdf    | No specimen was found.     |          |
    | 3       | Found 4 matching specimens | 1,4,5,12 |
    | 72      | Found 1 matching specimens | 3        |

  Scenario Outline: Search by topography
    When I fill in "Topography" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                     | results                    |
    | asdf    | No specimen was found.      |                            |
    | o_      | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | top     | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | topo_1  | Found 4 matching specimens  | 1,10,11,12                 |
    | topo_12 | Found 1 matching specimens  | 12                         |

  Scenario Outline: Search by aspect
    When I fill in "Aspect" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example   | message                     | results                    |
    | asdf      | No specimen was found.      |                            |
    | ct_       | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | asp       | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | aspect_1  | Found 4 matching specimens  | 1,2,3,12                   |
    | aspect_12 | Found 1 matching specimens  | 1                          |

  Scenario Outline: Search by substrate
    When I fill in "Substrate" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example      | message                     | results                    |
    | asdf         | No specimen was found.      |                            |
    | substrate_12 | No specimen was found.      |                            |
    | sub          | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | ate_         | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | substrate_2  | Found 5 matching specimens  | 8,9,10,11,12               |
    | substrate_20 | Found 1 matching specimens  | 8                          |

  Scenario Outline: Search by frequency
    When I fill in "Frequency" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example    | message                    | results           |
    | asdf       | No specimen was found.     |                   |
    | e          | Found 8 matching specimens | 1,3,4,6,7,9,10,12 |
    | rare       | Found 4 matching specimens | 1,4,7,10          |
    | occasional | Found 4 matching specimens | 2,5,8,11          |
    | frequent   | Found 4 matching specimens | 3,6,9,12          |

  Scenario Outline: Search by country
    When I fill in "Country" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example   | message                     | results                    |
    | asdf      | No specimen was found.      |                            |
    | a         | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | Australia | Found 4 matching specimens  | 1,2,6,12                   |
    | Malaysia  | Found 1 matching specimens  | 8                          |

  Scenario Outline: Search by state
    When I fill in "State" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example         | message                     | results                  |
    | asdf            | No specimen was found.      |                          |
    | a               | Found 11 matching specimens | 1,2,3,4,5,6,7,9,10,11,12 |
    | New South Wales | Found 3 matching specimens  | 1,6,12                   |
    | Alaska          | Found 1 matching specimens  | 7                        |

  Scenario Outline: Search by botanical division
    When I fill in "Botanical division" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example              | message                    | results |
    | asdf                 | No specimen was found.     |         |
    | a                    | Found 2 matching specimens | 1,12    |
    | Central Coast        | Found 1 matching specimens | 1       |
    | North Western Slopes | Found 1 matching specimens | 6       |

  Scenario Outline: Search by datum
    When I fill in "Datum" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                     | results                    |
    | asdf    | No specimen was found.      |                            |
    | a       | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | Dat     | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | m_      | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | b       | Found 2 matching specimens  | 2,8                        |
    | Datum_C | Found 2 matching specimens  | 3,9                        |

  Scenario Outline: Search by altitude
    When I fill in "search_altitude_greater_than_or_equal_to" with "<example_1>"
    When I fill in "search_altitude_less_than_or_equal_to" with "<example_2>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example_1 | example_2 | message                     | results                    |
    |           | 999       | No specimen was found.      |                            |
    | 12001     |           | No specimen was found.      |                            |
    | 1000      |           | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |           | 12000     | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 1000      | 12000     | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 1001      |           | Found 11 matching specimens | 2,3,4,5,6,7,8,9,10,11,12   |
    |           | 11999     | Found 11 matching specimens | 1,2,3,4,5,6,7,8,9,10,11    |
    | 1001      | 11999     | Found 10 matching specimens | 2,3,4,5,6,7,8,9,10,11      |
    | 3000      | 8000      | Found 6 matching specimens  | 3,4,5,6,7,8                |

# TODO how to test this?
  Scenario Outline: Search by accession number
    When I fill in "search_id_greater_than_or_equal_to" with "<example_1>"
    When I fill in "search_id_less_than_or_equal_to" with "<example_2>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example_1 | example_2 | message                     | results                    |
    |           | 0         | No specimen was found.      |                            |
    | 0         | 0         | No specimen was found.      |                            |
    | 0         |           | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |

  Scenario Outline: Search by naturalised
    When I choose "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example                                        | message                    | results                    |
    | search_determinations_naturalised_equals_true  | Found 8 matching specimens | 1,2,4,5,7,8,10,11          |
    | search_determinations_naturalised_equals_false | Found 4 matching specimens | 3,6,9,12                   |
    | search_determinations_naturalised_equals_      | Showing all 12 specimens   | 1,2,3,4,5,6,7,8,9,10,11,12 |

  Scenario Outline: Search by collection date
    When I fill in "search_collection_date_day_greater_than_or_equal_to" with "<day>"
    When I fill in "search_collection_date_month_greater_than_or_equal_to" with "<month>"
    When I fill in "search_collection_date_year_greater_than_or_equal_to" with "<year>"
    When I fill in "search_collection_date_day_less_than_or_equal_to" with "<day_to>"
    When I fill in "search_collection_date_month_less_than_or_equal_to" with "<month_to>"
    When I fill in "search_collection_date_year_less_than_or_equal_to" with "<year_to>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | year | month | day | year_to | month_to | day_to | message                     | results                    |
    | 2001 |       |     |         |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 2009 |       |     |         |          |        | Found 4 matching specimens  | 1,2,3,4                    |
    | 2009 | 04    |     |         |          |        | Found 4 matching specimens  | 1,2,3,4                    |
    | 2009 | 04    | 02  |         |          |        | Found 3 matching specimens  | 1,2,3                      |
    |      |       |     | 2012    |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |      |       |     | 2012    | 01       |        | Found 11 matching specimens | 2,3,4,5,6,7,8,9,10,11,12   |
    |      |       |     | 2011    | 02       | 11     | Found 10 matching specimens | 3,4,5,6,7,8,9,10,11,12     |
    | 2013 |       |     |         |          |        | No specimen was found.      |                            |
    | 2012 | 02    | 13  |         |          |        | No specimen was found.      |                            |
    |      |       |     | 2000    |          |        | No specimen was found.      |                            |
    |      |       |     | 2001    | 12       | 18     | No specimen was found.      |                            |
    | 2005 | 08    | 21  | 2008    | 06       | 05     | Found 3 matching specimens  | 5,6,7                      |

  Scenario Outline: Search by latitude hemisphere
    When I select "<example>" from "Latitude hemisphere"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                    | results                    |
    | None    | Showing all 12 specimens   | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | North   | Found 6 matching specimens | 1,3,5,7,9,11               |
    | South   | Found 6 matching specimens | 2,4,6,8,10,12              |

  Scenario Outline: Search by latitude
    When I fill in "search_latitude_degrees_greater_than_or_equal_to" with "<deg>"
    When I fill in "search_latitude_minutes_greater_than_or_equal_to" with "<min>"
    When I fill in "search_latitude_seconds_greater_than_or_equal_to" with "<sec>"
    When I fill in "search_latitude_degrees_less_than_or_equal_to" with "<deg_to>"
    When I fill in "search_latitude_minutes_less_than_or_equal_to" with "<min_to>"
    When I fill in "search_latitude_seconds_less_than_or_equal_to" with "<sec_to>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | deg | min | sec | deg_to | min_to | sec_to | message                     | results                    |
    | 30  |     |     |        |        |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 37  |     |     |        |        |        | Found 5 matching specimens  | 8,9,10,11,12               |
    | 37  | 7   |     |        |        |        | Found 5 matching specimens  | 8,9,10,11,12               |
    | 37  | 7   | 23  |        |        |        | Found 4 matching specimens  | 9,10,11,12                 |
    |     |     |     | 41     |        |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |     |     |     | 41     | 9      |        | Found 11 matching specimens | 1,2,3,4,5,6,7,8,9,10,11    |
    |     |     |     | 41     | 9      | 22     | Found 11 matching specimens | 1,2,3,4,5,6,7,8,9,10,11    |
    | 42  |     |     |        |        |        | No specimen was found.      |                            |
    | 41  | 9   | 24  |        |        |        | No specimen was found.      |                            |
    |     |     |     | 29     |        |        | No specimen was found.      |                            |
    |     |     |     | 30     | 4      | 19     | No specimen was found.      |                            |
    | 32  | 5   | 21  | 37     | 7      | 22     | Found 5 matching specimens  | 4,5,6,7,8                  |

  Scenario Outline: Search by longitude hemisphere
    When I select "<example>" from "Longitude hemisphere"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                    | results                    |
    | None    | Showing all 12 specimens   | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | East    | Found 6 matching specimens | 1,2,5,6,9,10               |
    | West    | Found 6 matching specimens | 3,4,7,8,11,12              |

  Scenario Outline: Search by longitude
    When I fill in "search_longitude_degrees_greater_than_or_equal_to" with "<deg>"
    When I fill in "search_longitude_minutes_greater_than_or_equal_to" with "<min>"
    When I fill in "search_longitude_seconds_greater_than_or_equal_to" with "<sec>"
    When I fill in "search_longitude_degrees_less_than_or_equal_to" with "<deg_to>"
    When I fill in "search_longitude_minutes_less_than_or_equal_to" with "<min_to>"
    When I fill in "search_longitude_seconds_less_than_or_equal_to" with "<sec_to>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | deg | min | sec | deg_to | min_to | sec_to | message                     | results                    |
    | 150 |     |     |        |        |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 157 |     |     |        |        |        | Found 5 matching specimens  | 8,9,10,11,12               |
    | 157 | 06  |     |        |        |        | Found 5 matching specimens  | 8,9,10,11,12               |
    | 157 | 06  | 43  |        |        |        | Found 4 matching specimens  | 9,10,11,12                 |
    |     |     |     | 161    |        |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |     |     |     | 161    | 04     |        | Found 11 matching specimens | 1,2,3,4,5,6,7,8,9,10,11    |
    |     |     |     | 161    | 04     | 42     | Found 11 matching specimens | 1,2,3,4,5,6,7,8,9,10,11    |
    | 162 |     |     |        |        |        | No specimen was found.      |                            |
    | 161 | 04  | 44  |        |        |        | No specimen was found.      |                            |
    |     |     |     | 149    |        |        | No specimen was found.      |                            |
    |     |     |     | 150    | 09     | 39     | No specimen was found.      |                            |
    | 152 | 08  | 41  | 157    | 06     | 42     | Found 5 matching specimens  | 4,5,6,7,8                  |

  Scenario Outline: Search by collector
    When I select "<example>" from "Collector"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example        | message                    | results |
    | D.B. Alexander | Found 3 matching specimens | 1,2,3   |
    | K.K. Anderson  | Found 2 matching specimens | 4,5     |
    | W.S. Kim       | No specimen was found.     |         |

  Scenario Outline: Search by collector number
    When I fill in "Collector number" with "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                    | results |
    | 14      | Found 1 matching specimens | 2       |
    | 21      | Found 1 matching specimens | 9       |
    | 25      | No specimen was found.     |         |


  Scenario Outline: Search by secondary collector
    When I select "<example>" from "Other collectors"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example         | message                    | results |
    | J.A. Cunningham | Found 1 matching specimens | 2       |
    | W.S. Kim        | Found 2 matching specimens | 2,6     |
    | K.K. Anderson   | No specimen was found.     |         |

  Scenario Outline: Search by replicate
    When I select "<example>" from "Replicate to"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                    | results |
    | DNA     | Found 1 matching specimens | 9       |
    | CAIRNS  | Found 2 matching specimens | 1,8     |
    | MEL     | No specimen was found      |         |

  Scenario Outline: Search by needs review
    When I choose "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example                          | message                    | results                    |
    | search_needs_review_equals_true  | Found 6 matching specimens | 1,2,3,4,5,6                |
    | search_needs_review_equals_false | Found 6 matching specimens | 7,8,9,10,11,12             |
    | search_needs_review_equals_      | Showing all 12 specimens   | 1,2,3,4,5,6,7,8,9,10,11,12 |

  Scenario Outline: Search by confirmer
    When I select "<example>" from "Confirmations confirmer"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example         | message                    | results |
    | J.A. Cunningham | Found 1 matching specimens | 6       |
    | W.S. Kim        | No specimen was found.     |         |

  Scenario Outline: Search by confirmation date
    When I fill in "search_confirmations_confirmation_date_day_equals" with "<day>"
    When I fill in "search_confirmations_confirmation_date_month_equals" with "<month>"
    When I fill in "search_confirmations_confirmation_date_year_equals" with "<year>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | year | month | day | message                    | results |
    | 2013 |       |     | Found 3 matching specimens | 4,5,6   |
    | 2013 | 12    |     | Found 2 matching specimens | 5,6     |
    | 2013 | 12    | 15  | Found 1 matching specimens | 5       |
    | 2012 |       |     | No specimen was found.     |         |

  Scenario Outline: Search by items
    When I check "<example>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example | message                    | results |
    | Fruit   | Found 3 matching specimens | 5,6,9   |
    | Photo   | No specimen was found.     |         |

  Scenario Outline: Search by determiner
    When I select "<example>" from "Determinations determiner"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | example         | message                    | results |
    | J.A. Cunningham | No specimen was found.     |         |
    | B.H. Price      | Found 1 matching specimens | 1       |
    | M.J. Perry      | Found 2 matching specimens | 9,10    |

  Scenario Outline: Search by determination date
    When I fill in "search_determinations_determination_date_day_greater_than_or_equal_to" with "<day>"
    When I fill in "search_determinations_determination_date_month_greater_than_or_equal_to" with "<month>"
    When I fill in "search_determinations_determination_date_year_greater_than_or_equal_to" with "<year>"
    When I fill in "search_determinations_determination_date_day_less_than_or_equal_to" with "<day_to>"
    When I fill in "search_determinations_determination_date_month_less_than_or_equal_to" with "<month_to>"
    When I fill in "search_determinations_determination_date_year_less_than_or_equal_to" with "<year_to>"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | year | month | day | year_to | month_to | day_to | message                     | results                    |
    | 2001 |       |     |         |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    | 2009 |       |     |         |          |        | Found 5 matching specimens  | 1,2,3,4,5                  |
    | 2009 | 04    |     |         |          |        | Found 5 matching specimens  | 1,2,3,4,5                  |
    | 2009 | 04    | 02  |         |          |        | Found 4 matching specimens  | 1,2,3,4                    |
    |      |       |     | 2013    |          |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |      |       |     | 2013    | 01       |        | Found 12 matching specimens | 1,2,3,4,5,6,7,8,9,10,11,12 |
    |      |       |     | 2013    | 01       | 11     | Found 11 matching specimens | 2,3,4,5,6,7,8,9,10,11,12   |
    | 2014 |       |     |         |          |        | No specimen was found.      |                            |
    | 2013 | 01    | 13  |         |          |        | No specimen was found.      |                            |
    |      |       |     | 2001    |          |        | No specimen was found.      |                            |
    |      |       |     | 2002    | 12       | 06     | No specimen was found.      |                            |
    | 2006 | 08    | 21  | 2009    | 06       | 05     | Found 3 matching specimens  | 5,6,7                      |

  Scenario Outline: Search by determination fields
    When I select "<division>" from "Determinations division"
    When I select "<class>" from "Determinations class name"
    When I select "<order>" from "Determinations order name"
    When I select "<family>" from "Determinations family"
    When I select "<subfamily>" from "Determinations subfamily"
    When I select "<genus>" from "Determinations genus"
    When I select "<species>" from "Determinations species"
    When I select "<subspecies>" from "Determinations subspecies"
    When I select "<variety>" from "Determinations variety"
    When I select "<tribe>" from "Determinations tribe"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:
    | division | class | order         | family    | subfamily | genus  | species  | subspecies         | variety           | tribe  | message                    | results |
    | Div1     |       |               |           |           |        |          |                    |                   |        | Found 3 matching specimens | 1,2,3   |
    |          | Cls2  |               |           |           |        |          |                    |                   |        | Found 1 matching specimens | 4,      |
    |          |       | Solanaceaeord |           |           |        |          |                    |                   |        | Found 3 matching specimens | 2,3,5   |
    |          |       |               | Juncaceae |           |        |          |                    |                   |        | Found 2 matching specimens | 4,6     |
    |          |       |               |           | Sub3      |        |          |                    |                   |        | Found 1 matching specimens | 3       |
    |          |       |               |           |           | Genus4 |          |                    |                   |        | Found 1 matching specimens | 4       |
    |          |       |               |           |           |        | Species1 |                    |                   |        | Found 1 matching specimens | 1       |
    |          |       |               |           |           |        |          | subspecies segunda |                   |        | Found 1 matching specimens | 2       |
    |          |       |               |           |           |        |          |                    | variety cinquenta |        | Found 1 matching specimens | 4       |
    |          |       |               |           |           |        |          |                    |                   | Tribe5 | Found 1 matching specimens | 5       |
    | Div1     | Cls2  |               |           |           |        |          |                    |                   |        | No specimen was found      |         |
    |          | Cls2  | Solanaceaeord |           |           |        |          |                    |                   |        | No specimen was found      |         |
    |          |       | Solanaceaeord | Juncaceae |           |        |          |                    |                   |        | No specimen was found      |         |
    |          |       |               | Juncaceae | Sub3      |        |          |                    |                   |        | No specimen was found      |         |
    |          |       |               |           | Sub3      | Genus4 |          |                    |                   |        | No specimen was found      |         |
    |          |       |               |           |           | Genus4 | Species1 |                    |                   |        | No specimen was found      |         |
    |          |       |               |           |           |        | Species1 | subspecies segunda |                   |        | No specimen was found      |         |
    |          |       |               |           |           |        |          | subspecies segunda | variety cinquenta |        | No specimen was found      |         |
    |          |       |               |           |           |        |          |                    | variety cinquenta | Tribe5 | No specimen was found      |         |
    | Div1     |       |               |           |           |        |          |                    |                   | Tribe5 | No specimen was found      |         |

  Scenario Outline: Search by determination uncertainties
    When I select "<species_un>" from "Determinations species uncertainty"
    When I select "<subspecies_un>" from "Determinations subspecies uncertainty"
    When I select "<variety_un>" from "Determinations variety uncertainty"
    When I select "<form_un>" from "Determinations form uncertainty"
    And I press "search_submit"
    And I should see "<message>"
    Then I should see specimens "<results>"

  Examples:

    | species_un | subspecies_un | variety_un | form_un   | message                    | results  |
    | aff.       |               |            |           | Found 3 matching specimens | 10,11,12 |
    |            | aff.          |            |           | Found 3 matching specimens | 1,5,9    |
    |            |               | aff.       |           | Found 3 matching specimens | 2,6,10   |
    |            |               |            | aff.      | Found 3 matching specimens | 3,7,11   |
    | vel. aff.  |               |            |           | Found 3 matching specimens | 7,8,9    |
    |            | vel. aff.     |            |           | Found 3 matching specimens | 2,6,10   |
    |            |               | vel. aff.  |           | Found 3 matching specimens | 3,7,11   |
    |            |               |            | vel. aff. | Found 3 matching specimens | 4,8,12   |
    | aff.       |               |            | vel. aff. | Found 1 matching specimens | 12       |
    |            | sens. strict. |            | vel. aff. | Found 3 matching specimens | 4,8,12   |
    |            |               | vel. aff.  | aff.      | Found 3 matching specimens | 3,7,11   |
    | aff.       | aff.          | aff.       | aff.      | No specimen was found      |          |

  Scenario: Search by all fields for specimen 1
    And I fill in "search_created_at_from_day" with "25"
    And I fill in "search_created_at_from_month" with "12"
    And I fill in "search_created_at_from_year" with "2012"
    And I fill in "search_created_at_to_day" with "01"
    And I fill in "search_created_at_to_month" with "01"
    And I fill in "search_created_at_to_year" with "2013"
    And I fill in "Locality" with "locality_1"
    And I fill in "Vegetation" with "vegetation_1"
    And I fill in "Plant description" with "plant_1"
    And I fill in "Replicate from" with "lycon"
    And I fill in "Replicate from number" with "36"
    And I fill in "Topography" with "topo_1"
    And I fill in "Aspect" with "aspect_12"
    And I fill in "Substrate" with "substr"
    And I fill in "Frequency" with "e"
    And I fill in "Country" with "a"
    And I fill in "State" with "al"
    And I fill in "Botanical division" with "a"
    And I fill in "Datum" with "a"
    And I fill in "search_altitude_greater_than_or_equal_to" with "999"
    And I fill in "search_altitude_less_than_or_equal_to" with "1001"

    #TODO Search by id
    And I fill in "search_id_greater_than_or_equal_to" with "0"
    And I fill in "search_id_less_than_or_equal_to" with ""

    And I choose "search_determinations_naturalised_equals_true"
    When I fill in "search_collection_date_day_greater_than_or_equal_to" with "11"
    When I fill in "search_collection_date_month_greater_than_or_equal_to" with "02"
    When I fill in "search_collection_date_year_greater_than_or_equal_to" with "2012"
    When I fill in "search_collection_date_day_less_than_or_equal_to" with "13"
    When I fill in "search_collection_date_month_less_than_or_equal_to" with "02"
    When I fill in "search_collection_date_year_less_than_or_equal_to" with "2012"

    When I select "North" from "Latitude hemisphere"

    When I fill in "search_latitude_degrees_greater_than_or_equal_to" with "30"
    When I fill in "search_latitude_minutes_greater_than_or_equal_to" with "4"
    When I fill in "search_latitude_seconds_greater_than_or_equal_to" with "19"
    When I fill in "search_latitude_degrees_less_than_or_equal_to" with "30"
    When I fill in "search_latitude_minutes_less_than_or_equal_to" with "4"
    When I fill in "search_latitude_seconds_less_than_or_equal_to" with "21"

    When I select "East" from "Longitude hemisphere"

    When I fill in "search_longitude_degrees_greater_than_or_equal_to" with "150"
    When I fill in "search_longitude_minutes_greater_than_or_equal_to" with "9"
    When I fill in "search_longitude_seconds_greater_than_or_equal_to" with "40"
    When I fill in "search_longitude_degrees_less_than_or_equal_to" with "150"
    When I fill in "search_longitude_minutes_less_than_or_equal_to" with "9"
    When I fill in "search_longitude_seconds_less_than_or_equal_to" with "40"

    And I fill in "search_determinations_determination_date_day_greater_than_or_equal_to" with "11"
    And I fill in "search_determinations_determination_date_month_greater_than_or_equal_to" with "01"
    And I fill in "search_determinations_determination_date_year_greater_than_or_equal_to" with "2013"
    And I fill in "search_determinations_determination_date_day_less_than_or_equal_to" with "13"
    And I fill in "search_determinations_determination_date_month_less_than_or_equal_to" with "01"
    And I fill in "search_determinations_determination_date_year_less_than_or_equal_to" with "2013"

    When I select "D.B. Alexander" from "Collector"

    When I fill in "Collector number" with "13"

    When I select "S.C. Austin" from "Other collectors"

    When I select "CAIRNS" from "Replicate to"

    When I choose "search_needs_review_equals_true"
    When I select "A.R. Wilson" from "Confirmations confirmer"

    When I fill in "search_confirmations_confirmation_date_day_equals" with "01"
    When I fill in "search_confirmations_confirmation_date_month_equals" with "04"
    When I fill in "search_confirmations_confirmation_date_year_equals" with "2014"

    When I check "Pollen"
    When I check "Bark"

    When I select "B.H. Price" from "Determinations determiner"

    When I fill in "search_determinations_determination_date_day_greater_than_or_equal_to" with "11"
    When I fill in "search_determinations_determination_date_month_greater_than_or_equal_to" with "01"
    When I fill in "search_determinations_determination_date_year_greater_than_or_equal_to" with "2013"
    When I fill in "search_determinations_determination_date_day_less_than_or_equal_to" with "13"
    When I fill in "search_determinations_determination_date_month_less_than_or_equal_to" with "01"
    When I fill in "search_determinations_determination_date_year_less_than_or_equal_to" with "2013"

    And I select "Div1" from "Determinations division"
    And I select "Cls1" from "Determinations class name"
    And I select "Myrtaceaeord" from "Determinations order name"
    And I select "Myrtaceae" from "Determinations family"
    And I select "Sub1" from "Determinations subfamily"
    And I select "Genus1" from "Determinations genus"
    And I select "Species1" from "Determinations species"
    And I select "subspecies primera" from "Determinations subspecies"
    And I select "var1" from "Determinations variety"
    And I select "Tribe1" from "Determinations tribe"
    And I select "sens. strict." from "Determinations species uncertainty"
    And I select "aff." from "Determinations subspecies uncertainty"
    And I select "sens. strict." from "Determinations variety uncertainty"
    And I select "sens. lat." from "Determinations form uncertainty"
    And I press "search_submit"
    And I should see "Found 1 matching specimens"
    Then I should see specimens "1"

