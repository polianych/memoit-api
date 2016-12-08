json.extract! rss_channel, :id, :slug, :created_at, :updated_at, :title, :description, :url, :rss_category_id
subscription_id = subscribed_ids.find{|x| x['publisher_id'] == rss_channel.id}.try(:[], 'id')
json.subscribed !!subscription_id
json.subscription_id subscription_id
