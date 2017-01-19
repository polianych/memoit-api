class AddIndexesForSubscriptions < ActiveRecord::Migration[5.0]
  def change
    add_index :subscriptions, :publisher_id
    add_index :subscriptions, [:publisher_id, :publisher_type]
    add_index :subscriptions, [:publisher_id, :publisher_type, :user_id], name: 'index_subscriptions_on_publisher_and_user'
  end
end
