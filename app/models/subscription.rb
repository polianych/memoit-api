class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :publisher, polymorphic: true
  validates_presence_of :user, :publisher_type, :publisher_id

  def self.pluck_to_hash(keys)
    pluck(*keys).map{|pa| Hash[keys.zip(pa)]}
  end

  def self.with_user_subscriptions(user, where_condition = {} )
    user_id = user ? user.id : 'NULL'
    select("subscriptions.*, sb.id as user_subscription_id").with_publisher_data.where(where_condition).joins(
      "LEFT JOIN subscriptions as sb ON sb.publisher_id = subscriptions.publisher_id AND sb.publisher_type = subscriptions.publisher_type AND sb.user_id = #{user_id}"
    )
  end

  def self.with_publisher_data
    joins = [
      "LEFT JOIN rss_channels as rc ON subscriptions.publisher_id = rc.id AND subscriptions.publisher_type = 'RssChannel'",
      "LEFT JOIN users as u ON subscriptions.publisher_id = u.id AND subscriptions.publisher_type = 'User'"
    ]
    selects = [
      "CASE subscriptions.publisher_type WHEN 'RssChannel' THEN rc.title WHEN 'User' THEN u.nickname END as publisher_title",
      "CASE subscriptions.publisher_type WHEN 'RssChannel' THEN rc.slug  WHEN 'User' THEN u.nickname END as publisher_slug",

    ]
    select(selects.join(", ")).joins(joins.join(" "))
  end
end
