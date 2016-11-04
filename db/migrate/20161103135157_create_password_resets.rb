class CreatePasswordResets < ActiveRecord::Migration[5.0]
  def change
    create_table :password_resets do |t|
      t.string     :uri
      t.string     :token_hash
      t.datetime   :expiry
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :password_resets, :uri, :unique => true
  end
end
