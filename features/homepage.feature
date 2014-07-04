Feature: Display of homepage
  In order to ensure correct attributions
  As the system owner
  I want the the website to display certain things

  Background:
    Given I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"

  Scenario: Ensure that information appears about how to cite NE appears
    Given I am on the home page
    Then I should see "Citations"
    Then I should see "Please cite use of this database in papers, theses, reports, etc. as follows:"
    Then I should see "NE-db (year). N.C.W. Beadle Herbarium (NE) database (NE-db). Version 1, Dec 2010 [and more or less continuously updated since] www.une.edu.au/herbarium/nedb, accessed [day month year]."
    Then I should see "And/or acknowledge use of the data as follows:"
    Then I should see "I/we acknowledge access and use of data from the N.C.W. Beadle Herbarium (NE) database (NE-db)."

  Scenario: Ensure that Intersect Attribution is on every page
    Given I am on the home page
    Then I should see "Developed by Intersect Australia Ltd"
    When I follow "Latest 40"
    Then I should see "Developed by Intersect Australia Ltd"
    When I follow "Admin"
    Then I should see "Developed by Intersect Australia Ltd"
    When I follow "Advanced Search"
    Then I should see "Developed by Intersect Australia Ltd"