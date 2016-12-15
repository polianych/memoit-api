class Post < ApplicationRecord
  belongs_to :publisher, polymorphic: true
  belongs_to :postable,  polymorphic: true, dependent: :destroy, optional: true
  belongs_to :rss_post,  foreign_key: 'postable_id', optional: true
  belongs_to :user_post, foreign_key: 'postable_id', optional: true
  belongs_to :rss_channel, foreign_key: 'publisher_id', optional: true
  belongs_to :user, foreign_key: 'publisher_id', optional: true
  has_many   :video_sources, class_name: 'Post::VideoSource'
  validates_presence_of :content, :publisher

  scope :with_meta_data, -> { eager_load(:rss_post, :user_post, :rss_channel, :user, :video_sources).order(published_at: :desc) }

  after_validation :set_defaults

  def set_defaults
    self.title        ||= content.split(" ").first(12).join(" ")
    self.published_at ||= DateTime.now
  end

  def self.for_user(user)
    with_meta_data
    .joins(
      'LEFT JOIN "subscriptions" ON "subscriptions"."publisher_type"="posts"."publisher_type"
       AND "subscriptions"."publisher_id"="posts"."publisher_id"'
    ).where('"subscriptions"."user_id" = ? ', user.id)
  end

end
