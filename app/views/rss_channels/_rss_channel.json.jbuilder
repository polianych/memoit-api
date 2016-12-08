json.extract! rss_channel, :id, :slug, :created_at, :updated_at, :title, :description, :url, :rss_category_id
json.subscribed subscribed_ids.include?(rss_channel.id)
