class RssChannel < ApplicationRecord
  belongs_to :rss_category
  has_many :posts, as: :publisher, dependent: :destroy, autosave: true
  validates_presence_of   :rss_category, :url, :title, :slug
  validates_format_of     :slug, :with => /\A[a-zA-Z][\w\d]*\z/, message: "only letters, numbers and undersoce"
  validates_uniqueness_of :url, :slug

  def import_new_posts
    feed = Feedjira::Feed.fetch_and_parse url
    guids = posts.eager_load(:rss_post).pluck(:'rss_posts.guid')
    new_rss_posts = []
    feed.entries.each do |item|
      next if guids.include?(item.entry_id)
      new_rss_posts << RssPost.create({
        post_attributes: {
          title: item.title,
          content: item.summary,
          publisher: self,
          published_at: item.published
        },
        raw_content: item.summary,
        guid: item.entry_id,
        link: item.url,
        media_thumbnail: item.image
      })
    end
    update_attributes(imported_at: DateTime.now, import_error: nil)
    new_rss_posts
  rescue Exception => e
    update_attributes(imported_at: DateTime.now, import_error: e)
    []
  end

  def self.save_by_url(url, rss_category, slug)
    feed = Feedjira::Feed.fetch_and_parse url
    create(
      url: url,
      rss_category: rss_category,
      title: feed.title,
      slug: slug,
      description: feed.description
    )
  end
end
