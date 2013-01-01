Feature: Uploading images for specimens
  In order to store specimen images in the system
  As a user
  I want to upload my images

  Background:
    Given I have a specimen
    And I have the usual profiles and permissions
    And I have a user "georgina@intersect.org.au" with profile "Superuser"
    And I am logged in as "georgina@intersect.org.au"
    And I am on the specimen page
    When I follow "Add Image"
    Then I should see "Upload New Image"

  Scenario: Successful Image Upload
    When I attach an image file
    And I fill in "Description" with "desc1"
    And I press "Upload"
    Then I should see "The specimen image was uploaded successfully."

  Scenario: Failed upload with empty form
    And I press "Upload"
    Then I should see "Upload New Image"
    And I should see "Image file name must be set."
    And I should see "Description can't be blank"

  Scenario: Failed upload with no description
    When I attach an image file
    And I press "Upload"
    Then I should see "Upload New Image"
    And I should see "Description can't be blank"

  Scenario: Failed upload with no image
    And I fill in "Description" with "desc1"
    And I press "Upload"
    Then I should see "Upload New Image"
    And I should see "Image file name must be set."

  Scenario: Failed upload with image larger than 10MB
    When I attach a huge image file
    And I press "Upload"
    Then I should see "Upload New Image"
    And I should see "Image file size must be less than 10MB"

  Scenario: Click back
    Then I follow "Cancel"
    Then I should be on the specimen page
