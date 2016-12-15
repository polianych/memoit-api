class CreatePostVideoSources < ActiveRecord::Migration[5.0]
  def change
    create_table :post_video_sources do |t|
      t.references :post, foreign_key: true
      t.string :source_url
      t.string :mime_type

      t.timestamps
    end
  end
end
