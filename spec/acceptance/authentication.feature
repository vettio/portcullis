Feature: Authentication
  Background:
    When I go to the sign-up page

  @backlog
  Scenario: works with Facebook
    When I sign up with Facebook 
    Then A new user should be created from data from facebook

  @backlog
  Scenario: fails with Facebook
    When I sign up with Facebook
    And the provider is bound to fail
    Then I should see an error

  @backlog
  Scenario: works with LinkedIn
    When I sign up with LinkedIn 
    Then A new user should be created from data from linkedin

  @backlog
  Scenario: fails with LinkedIn
    When I sign up with LinkedIn
    And the provider is bound to fail
    Then I should see an error
