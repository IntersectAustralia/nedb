Feature: Delete specimen image
  In order to correct my mistakes
  As a user
  I want to delete specimen images
  
  Background:
    Given I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I have a specimen image
    And I am logged in as "georgina@intersect.org.au"
    And I am on the specimen image page
  
  Scenario: Delete Image
    When I follow "Delete Image"
    Then I should see "The image was successfully deleted."
    And I should see no images

