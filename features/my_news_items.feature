Feature: My News Items
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

Scenario: User can search articles from display article page 
  When I go to the "Joe Biden" news article page
  Then I should see "Listing News Articles for Joe Biden"
  When I follow "Search For News Articles"
  Then I should be on the Select Representative and Issue page

Scenario: User can add a news article from display article page 
  When I go to the "Joe Biden" news article page
  Then I should see "Listing News Articles for Joe Biden"
  When I follow "Add News Article"
  Then I should be on the Add News Article page

Scenario: User should be able to navigate to a profile while viewing articles
  Given I have added an article and I am on the "Joe Biden" news article page
  When I follow "View all articles"
  Then I should see "Listing News Articles for Joe Biden"
  When I follow "Representative Profile"
  Then I should see "Joe Biden"


  


