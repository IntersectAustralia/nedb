Feature: Editing descriptions for specimen images
  In order for other people to know the origin of an image
  As a user
  I want to be able to edit its description

  Background:
    Given I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I have a specimen image with a Description "desc1" and filename "filename.jpg" and uploader "georgina@intersect.org.au"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the specimen image page

  Scenario: Successful Edit of Image Description
    Given I am on the specimen image page
    When I follow "Edit Description"
    Then I should see "Edit Image Description"
    And the "Description" field should contain "desc1"
    And I fill in "Description" with "desc2"
    And I press "Save"
    Then I should be on the specimen image page
    And I should see "desc2"
    And I should see "The specimen image description was successfully updated."

  Scenario: Unsuccessful Edit of Image Description
    Given I am on the specimen image page
    When I follow "Edit Description"
    Then I should see "Edit Image Description"
    And the "Description" field should contain "desc1"
    And I fill in "Description" with ""
    And I press "Save"
    Then I should see "Edit Image Description"
    And I should see "Description can't be blank"

  Scenario: Cancel out of editing
    Then I follow "Edit Description"
    Then I follow "Cancel"
    Then I should be on the specimen image page

