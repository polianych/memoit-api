class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :nickname
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :uid
      t.string :provider

      t.timestamps
    end
  end
end
