Feature: Submit Feedback
  In order to improve the system
  As a user
  I want to submit feedback

  Background:
    Given I have the usual profiles and permissions
    And I have a user "diego.alonso@intersect.org.au" with profile "Superuser"
    And I am logged in as "diego.alonso@intersect.org.au"

  Scenario: Submit Feedback
    When I follow "Submit Feedback"
    And I fill in "feedback" with "This is my feedback"
    And I press "Submit Feedback"
    Then "diego.alonso@intersect.org.au" should receive an email
    When I open the email
    Then I should see "This is my feedback" in the email body
