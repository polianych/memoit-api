json.extract! rss_channel, :id, :slug, :created_at, :updated_at, :title, :description, :url, :rss_category_id
json.subscribed !!rss_channel.user_subscription_id
json.subscription_id rss_channel.user_subscription_id
