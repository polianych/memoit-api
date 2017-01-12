json.extract! subscription, :id, :created_at, :user_id, :publisher_type, :publisher_id, :user_subscription_id, :publisher_title
json.subscribed !!subscription.user_subscription_id
