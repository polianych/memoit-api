json.rss_channels @rss_channels, partial: 'rss_channels/rss_channel', as: :rss_channel
json.meta do
  json.total_pages @rss_channels.total_pages
  json.current_page @rss_channels.current_page
end
