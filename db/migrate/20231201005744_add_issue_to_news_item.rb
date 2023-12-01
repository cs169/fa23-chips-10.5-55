class AddIssueToNewsItem < ActiveRecord::Migration[5.2]
  def change
    add_column :news_item, :issue, :string
  end
end
