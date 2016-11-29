class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.string     :title
      t.text       :content
      t.references :postable, polymorphic: true
      t.references :publisher, polymorphic: true
      t.datetime   :published_at
      t.timestamps
    end
  end
end
