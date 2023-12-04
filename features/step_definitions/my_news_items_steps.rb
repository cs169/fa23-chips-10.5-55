# frozen_string_literal: true

When('I select a representative {string}') do |representative_name|
  expect(page).to have_select('news_item[representative_id]')

  select representative_name, from: 'news_item[representative_id]'
end

Given('I have added an article and I am on the {string} news article page') do |_representative_name|
  step 'I am on the select representative and issue page'
  step 'I select a representative "Joe Biden"'
  step 'I select a issue "Terrorism"'
  step 'I press "Search"'
  step 'I select the first news article'
  step 'I press "Save"'
end

When('I select a issue {string}') do |issue_name|
  expect(page).to have_select('news_item[issue]')

  select issue_name, from: 'news_item[issue]'
end

When('I should be on the Select Representative and Issue page') do
  expect(page).to have_content('Select Representative and Issue')
end

When('I should be on the Add News Article page') do
  expect(page).to have_content('Add News Article')
end

Then('I should see the displayed news articles') do
  expect(page).to have_css('table.table.table-striped.table-hover')
  within('table.table.table-striped.table-hover') do
    expect(page).to have_content('Title')
    expect(page).to have_content('Description')
    expect(page).to have_content('Link')
  end
end

And('I should see {string} as the news article title') do |title|
  within('table.table.table-striped.table-hover') do
    expect(page).to have_content(title)
  end
end

And('I should see {string} as the news article description') do |description|
  within('table.table.table-striped.table-hover') do
    expect(page).to have_content(description)
  end
end

Given('I have selected a representative and an issue') do
  step 'I am on the select representative and issue page'
  step 'I select a representative "Joe Biden"'
  step 'I select a issue "Terrorism"'
  step 'I press "Search"'
end

And('I select the first news article') do
  first('input[type="radio"]').set(true)
end

Given('I see how many news articles exist now') do
  @initial_news_items_count = NewsItem.count
end

Then('the news article should be saved') do
  expect(NewsItem.count).to eq(@initial_news_items_count + 1)
  expect(page).to have_content('News item was successfully created.')
end
