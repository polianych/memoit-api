class AddSlugToRssChannel < ActiveRecord::Migration[5.0]
  def change
    add_column :rss_channels, :slug, :string
  end
end
