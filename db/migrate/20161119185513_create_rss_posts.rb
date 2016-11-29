class CreateRssPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :rss_posts do |t|
      t.string :link
      t.string :media_thumbnail
      t.string :guid
      t.timestamps
    end
  end
end
