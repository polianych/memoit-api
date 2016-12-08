json.rss_categories @rss_categories, partial: 'rss_categories/rss_category', as: :rss_category
json.meta do
  json.total_pages @rss_categories.total_pages
  json.current_page @rss_categories.current_page
end
