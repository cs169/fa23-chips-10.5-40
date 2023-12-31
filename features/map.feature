Feature: Map interaction

Background: seed
  Given these representatives exist:
  |name| id |
  |Test| 1 |

  Given the setup needed x

Scenario: See representatives in Contra Costa County, CA
  Given I am on the home page
  When I click the state "CA"

Scenario: See representatives
  Given I am on the representatives page

Scenario: View map ajax
  Given I am on the home page
  When I visit the page ajax/state/CA

Scenario: View my feature
  Given I am on the home page
  When I visit the page representatives/1/representatives/1/my_news_item/new

Scenario: See representative Newsom
  Given I am on the home page
  When I visit the page representatives/1/news_items

Scenario: View map std_flip
  Given I am on the home page
  When I visit the page state/CA
  Then I should see "Counties in California"
  When I press "Counties in California"