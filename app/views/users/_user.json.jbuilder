json.extract! user, :id, :nickname, :name, :email, :uid, :provider, :created_at, :updated_at
if user.respond_to?(:user_subscription_id)
  json.subscribed !!user.user_subscription_id
  json.user_subscription_id user.user_subscription_id
end
