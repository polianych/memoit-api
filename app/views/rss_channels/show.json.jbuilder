json.rss_channel do
  json.partial! "rss_channels/rss_channel", rss_channel: @rss_channel, subscribed_ids: @subscribed_ids
end
