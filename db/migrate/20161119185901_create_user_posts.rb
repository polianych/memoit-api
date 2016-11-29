class CreateUserPosts < ActiveRecord::Migration[5.0]
  def change
    create_table :user_posts do |t|
      t.string :link
      t.string :image_url
      t.string :video_url

      t.timestamps
    end
  end
end
