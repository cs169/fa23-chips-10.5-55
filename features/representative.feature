Feature: Representative

Background: Create a representative
  Given I create the following representative:
    | name | title | ocdid | line1 | city | state | zip | party | photo_url |
    | mock_name | mock_title | mock_ocdid | mock_line1 | mock_city | mock_state | mock_zip | mock_party | mock_photo_url.png |

Scenario: Show the representative view 
  When I go to the "mock_name" profile page
  And I should see the representative's photo with src "mock_photo_url.png"
  And I should see "mock_name"
  And I should see "mock_title"
  And I should see "mock_ocdid"
  And I should see "mock_line1"
  And I should see "mock_city"
  And I should see "mock_state"
  And I should see "mock_zip"
  And I should see "mock_party"


