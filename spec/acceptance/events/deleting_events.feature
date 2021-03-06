Feature: Deleting Events
  Background:
    Given a host is signed in

  @backlog
  Scenario: Deletes an event
    When I have a pre-existing event
    And I go to view the event
    And I click on 'Delete'
    And I'm prompted to delete the event
    And I confirm the deletion of this event
    Then the pre-existing event should be deleted
    And it should be on the home page
