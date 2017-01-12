module JoinUserSubscription
  extend ActiveSupport::Concern


  class_methods do
    def with_user_subscriptions(where_condition, user)
      user_id = user ? user.id : 'NULL'
      select("#{table_name}.*, sb.id as user_subscription_id").where(where_condition).joins(
        "LEFT JOIN subscriptions as sb ON sb.publisher_id = #{table_name}.id AND sb.publisher_type = '#{model_name.name}' AND sb.user_id = #{user_id}"
      )
    end
  end
end
