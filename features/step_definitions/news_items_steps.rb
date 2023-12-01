Given("I create the following news item") do |table|
  table.hashes.each do |news_item_data|
    NewsItem.create!(news_item_data)
  end
  
  @news_item = NewsItem.create(title: 'Fake News', description: 'Fake content', representative_id: 0)
end