Feature: Wiki page contents

  Background:
    Given I have signed in with valid credentials

  Scenario: Creation of a page link
    When I create a page with content "Link to new [Test me] page"

    Then I can see a hyperlink to a "Test me" page

  Scenario: Creation of a url
    When I create a page with content "Link to new [http://hedtek.com] page"

    Then I can see a hyperlink to a "http://hedtek.com" page

  Scenario: Creation of a url with text
    When I create a page with content "Link to new [http://hedtek.com hedtek home] page"

    Then I can see a hyperlink to a "hedtek home" page

  Scenario: Creation of an image
    When I create a page with content "Link to new [http://hedtek.com/im.png] page"

    Then I can see a rendition of an image

  Scenario: Creation of YouTube content
    When I create a page with content "Link to new [https://www.youtube.com/watch?v=GNTvWxl3Isw] page"

    Then I can see Youtube video "GNTvWxl3Isw"

  Scenario: Creation of Vimeo content
    When I create a page with content "Link to new [http://vimeo.com/originals/ownyourtomorrow/93491987] page"

    Then I can see Vimeo video "93491987"