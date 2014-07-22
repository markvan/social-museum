Feature: Resource editing

  Background:
    Given I have signed in with valid credentials

  Scenario: Edit resource description
    When I create a new resource with a description of "Test"
    And I change the resource description to "Mario Testino"

    Then I can see a resource with description "Mario Testino"

  Scenario: Edit resource title
    When I create a new resource with a link to "http://media.npr.org/images/picture-show-flickr-promo.jpg"
    And I change the resource title to "Test2"

    Then I can see a resource with a link to "http://media.npr.org/images/picture-show-flickr-promo.jpg"

  # TODO Establish whether this is or is not desirable - app/models/resource.rb and app/views/resources/index.html.haml
  Scenario: Edit resource title to a pre-existing title
    When I create a new resource entitled "Test1"
    And I create a new resource entitled "Test2"
    And I change the resource title to "Test1"

    Then I can see a "has already been taken" error for the resource title