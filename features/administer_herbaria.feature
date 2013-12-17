Feature: Administer Herbaria
  In order to manage herbaria in the system
  As an administrator
  I want to view and edit herbaria

  Background:
    Given I have herbaria
      | code | name                               |
      | ACH  | Women's and Children's Hospital    |
      | AD   | State Herbarium of South Australia |
      | KPBG | Kings Park and Botanic Garden      |
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the homepage
    When I follow "Admin"
    And I follow "Manage Herbaria"
    Then I should see "List of Herbaria"
    And I should see "search_results_table" table with
      | Code | Name                               |
      | ACH  | Women's and Children's Hospital    |
      | AD   | State Herbarium of South Australia |
      | KPBG | Kings Park and Botanic Garden      |

  Scenario: Add new Herbarium
    When I click on "Add Another Herbarium"
    And I fill in "Code" with "CNS"
    And I fill in "Name" with "Australian Tropical Herbarium"
    And I press "Create Herbarium"
    Then I should see "search_results_table" table with
      | Code | Name                               |
      | ACH  | Women's and Children's Hospital    |
      | AD   | State Herbarium of South Australia |
      | CNS  | Australian Tropical Herbarium      |
      | KPBG | Kings Park and Botanic Garden      |

  Scenario Outline: Add Herbarium with validation errors
    When I click on "Add Another Herbarium"
    And I fill in "<field>" with "<value>"
    And I press "Create Herbarium"
    Then I should see /\d error(s)? need to be corrected before this record can be saved\./
    And the "<field>" field should have the error "<error>"

  Examples:
    | field | value        | error                                                                              |
    | Code  |              | can't be blank                                                                     |
    | Code  | []!@#$%^&*(* | Herbarium code can ony contain letters, numbers, spaces and characters . % - / $ + |
    | Name  |              | can't be blank                                                                     |

  Scenario: Editing existing Herbarium
    When I follow the edit link for herbarium "ACH"
    And I fill in "Code" with "MQU"
    And I fill in "Name" with "Macquarie University"
    And I press "Update Herbarium"
    Then I should see "search_results_table" table with
      | Code | Name                               |
      | AD   | State Herbarium of South Australia |
      | KPBG | Kings Park and Botanic Garden      |
      | MQU  | Macquarie University               |

  Scenario: Cancel an edit
    When I follow the edit link for herbarium "ACH"
    And I fill in "Code" with "MQU"
    And I fill in "Name" with "Macquarie University"
    And I click on "Cancel"
    Then I should see "search_results_table" table with
      | Code | Name                               |
      | ACH  | Women's and Children's Hospital    |
      | AD   | State Herbarium of South Australia |
      | KPBG | Kings Park and Botanic Garden      |

  Scenario Outline: Edit existing Herbarium with validation errors
    When I follow the edit link for herbarium "ACH"
    And I fill in "<field>" with "<value>"
    And I press "Update Herbarium"
    Then I should see /\d error(s)? need to be corrected before this record can be saved\./
    And the "<field>" field should have the error "<error>"

  Examples:
    | field | value        | error                                                                              |
    | Code  |              | can't be blank                                                                     |
    | Code  | []!@#$%^&*(* | Herbarium code can ony contain letters, numbers, spaces and characters . % - / $ + |
    | Name  |              | can't be blank                                                                     |
