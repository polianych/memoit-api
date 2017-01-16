class AddIndexForNameNicknameInUsers < ActiveRecord::Migration[5.0]
  def up
    enable_extension 'pg_trgm'
    enable_extension 'btree_gin'
    add_index :users, "name gin_trgm_ops", using: :gin, name: 'index_users_on_name_gin_trgm_ops'
    add_index :users, "nickname gin_trgm_ops", using: :gin, name: 'index_users_on_nickname_gin_trgm_ops'
  end


  def down
    remove_index :users, name: 'index_users_on_name_gin_trgm_ops'
    remove_index :users, name: 'index_users_on_nickname_gin_trgm_ops'
    disable_extension 'pg_trgm'
    disable_extension 'btree_gin'
  end
end
