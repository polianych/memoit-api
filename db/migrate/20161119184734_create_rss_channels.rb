class CreateRssChannels < ActiveRecord::Migration[5.0]
  def change
    create_table :rss_channels do |t|
      t.string :title
      t.string :description
      t.string :url
      t.string :image_url
      t.references :rss_category, foreign_key: true

      t.timestamps
    end
  end
end
