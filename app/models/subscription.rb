class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :publisher, polymorphic: true
  validates_presence_of :user, :publisher_type, :publisher_id
  belongs_to :publisher_rss_channel, class_name: 'RssChannel', foreign_key: 'publisher_id', optional: true
  belongs_to :publisher_user, class_name: 'User', foreign_key: 'publisher_id', optional: true
  scope :with_meta_data, -> { eager_load(:publisher_rss_channel, :publisher_user).order(created_at: :asc) }
end
