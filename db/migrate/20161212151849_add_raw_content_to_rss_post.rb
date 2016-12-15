class AddRawContentToRssPost < ActiveRecord::Migration[5.0]
  def change
    add_column :rss_posts, :raw_content, :text
  end
end
