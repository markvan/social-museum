Feature: Wiki page removal

  Background:
    Given I have signed in with valid credentials

  Scenario: Admins can remove pages
    When I turn an existing user into an administrator
    And I create a page entitled "Test" with content "Test me"
    And I remove a page entitled "Test" with content "Test me"

    Then I can't see a page entitled "Test" with content "Test me"

  Scenario: Standard users cannot remove pages
    When I create a page entitled "Test" with content "Test me"

    Then I cannot see the remove page link