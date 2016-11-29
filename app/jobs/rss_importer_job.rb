class RssImporterJob < ApplicationJob
  queue_as :default

  def perform(rss_channel_id)
    rss_channel = RssChannel.find(rss_channel_id)
    rss_channel.import_new_posts
  end
end
