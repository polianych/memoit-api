class CreateUserTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :user_tokens do |t|
      t.integer  :user_id
      t.string   :client
      t.datetime :expiry
      t.string   :token_hash

      t.timestamps
    end
  end
end
