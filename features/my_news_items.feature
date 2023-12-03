Feature: Search for and save a news item 
Background: Create a representative
  Given I create the following representative:
    | name | title | ocdid | line1 | city | state | zip | party | photo_url |
    | Joe Biden | mock_title | mock_ocdid | mock_line1 | mock_city | mock_state | mock_zip | mock_party | mock_photo_url.png |

Scenario: User selects representative and issue 
  Given I am on the select representative and issue page
  When I select a representative "Joe Biden"
  And I select a issue "Terrorism" 
  When I press "Search"
  And I should see "Representative: Joe Biden" 
  And I should see "Issue: Terrorism"
  And I should see the displayed news articles
  And I should see "Mock Title" as the news article title
  And I should see "Mock Description" as the news article description

Scenario: User selects and saves an article
  Given I have selected a representative and an issue 
  And I should see the displayed news articles
  And I select the first news article
  And I see how many news articles exist now
  When I press "Save"
  Then the news article should be saved
