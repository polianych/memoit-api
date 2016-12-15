class AddParseErrorToRssChannel < ActiveRecord::Migration[5.0]
  def change
    add_column :rss_channels, :import_error, :text
    add_column :rss_channels, :imported_at, :datetime
  end
end
