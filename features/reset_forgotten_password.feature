Feature: Reset forgotten password
  In order to access the system
  As a user
  I want to be able to reset my password if I forgot it

  Scenario: Reset forgotten password
    Given I have a user "georgina@intersect.org.au"
    And a clear email queue
    And I am on the login page
    When I follow "Forgot your password?"
    And I fill in "Email" with "georgina@intersect.org.au"
    And I press "Submit"
    Then "georgina@intersect.org.au" should receive an email
    When I open the email
    Then I should see "You requested to reset your password for the NCW Beadle Herbarium site. You can do this by clicking the link below." in the email body
    When I follow "Change my password" in the email
    Then I should see "Change Your Password"
    When I fill in "user_password" with "Pass.456"
    And I fill in "Password confirmation" with "Pass.456"
    And I press "Change my password"
    Then I should see "Your password was changed successfully. You are now signed in."
    And I should be able to log in with "georgina@intersect.org.au" and "Pass.456"
    
  Scenario: Deactivated user can't request a reset
    Given I have a user "georgina@intersect.org.au"
    And "georgina@intersect.org.au" is deactivated
    And I am on the login page
    When I follow "Forgot your password?"
    And I fill in "Email" with "georgina@intersect.org.au"
    And I press "Submit"
    Then I should see "Your account is not active."

  Scenario: Pending approval user can't request a reset
    Given I have a user "georgina@intersect.org.au"
    And "georgina@intersect.org.au" is pending approval
    And I am on the login page
    When I follow "Forgot your password?"
    And I fill in "Email" with "georgina@intersect.org.au"
    And I press "Submit"
    Then I should see "Your account is not active."

  Scenario: Rejected as spam user can't request a reset
    Given I have a user "georgina@intersect.org.au"
    And "georgina@intersect.org.au" is rejected as spam
    And I am on the login page
    When I follow "Forgot your password?"
    And I fill in "Email" with "georgina@intersect.org.au"
    And I press "Submit"
    Then I should see "Your account is not active."

  Scenario: Non existent user can't request a reset
    Given I am on the login page
    When I follow "Forgot your password?"
    And I fill in "Email" with "asdfasdf@intersect.org.au"
    And I press "Submit"
    Then I should see "Email not found"
