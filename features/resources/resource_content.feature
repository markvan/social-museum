Feature: Wiki page contents

  Background:
    Given I have signed in with valid credentials

  Scenario: Creation of an image
    When I create a new resource with a link to "http://media.npr.org/images/picture-show-flickr-promo.jpg"

    Then I can see a rendition of an image

  @wip
  Scenario: Creation of YouTube resource
    When I create a new resource with a link to "http://www.youtube.com/watch?v=vGakGgd-pDs"

    Then I can see Youtube video "vGakGgd-pDs"

  @wip
  Scenario: Creation of Vimeo resource
    When I create a new resource with a link to "http://vimeo.com/originals/ownyourtomorrow/93491987"

    Then I can see Vimeo video "93491987"