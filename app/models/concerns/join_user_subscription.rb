module JoinUserSubscription
  extend ActiveSupport::Concern


  class_methods do
    def with_user_subscriptions(user)
      user_id = user ? user.id : 'NULL'
      output = self
      output.select("#{table_name}.*, sb.id as user_subscription_id").joins(
        "LEFT JOIN subscriptions as sb ON sb.publisher_id = #{table_name}.id AND sb.publisher_type = '#{model_name.name}' AND sb.user_id = #{user_id}"
      ).where("sb.publisher_id IN (#{output.pluck(:id).join(',')}) OR sb.publisher_type IS NULL")
    end
  end
end
