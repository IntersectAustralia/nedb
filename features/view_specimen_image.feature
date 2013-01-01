Feature: Viewing images for specimens
  In order to view specimen images in the system
  As a user
  I want to view the specimen images

  Background:
    Given I have the usual profiles and permissions
    And I have a specimen image with a Description "desc1" and filename "filename.jpg" and uploader "harry@intersect.org.au" with profile "Superuser"
    And I am logged in as "harry@intersect.org.au"
    And I am on the specimen page

  Scenario: Successful Image View
    Given I am on the specimen page
    When I follow "desc1"
    Then I should see image "filename.jpg"
    And I should see upload metadata with user "harry@intersect.org.au"
    And I should see "desc1"
    And I should see "Back"
    And I should see "Edit Description"
    And I should see "Delete Image"

  Scenario: Click back
    When I follow "desc1"
    Then I follow "Back" within the main content
    Then I should see "Specimen Details"

