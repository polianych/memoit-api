json.extract! subscription, :id, :created_at, :user_id, :publisher_type
case subscription.publisher_type
when 'RssChannel'
  json.publisher do
    json.partial! "rss_channels/rss_channel_short", rss_channel: subscription.publisher_rss_channel
  end
when 'User'
  json.publisher do
    json.partial! "users/user_short", user: subscription.publisher_user
  end
end
