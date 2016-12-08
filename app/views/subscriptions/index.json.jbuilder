json.subscriptions @subscriptions, partial: 'subscriptions/subscription', as: :subscription
json.meta do
  json.total_pages @subscriptions.total_pages
  json.current_page @subscriptions.current_page
end
