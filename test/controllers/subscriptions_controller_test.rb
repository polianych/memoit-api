require 'test_helper'

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
    @user_token = UserToken.create(user_id: @user.id)
    @auth_headers = { 'Authorization' => @user_token.token, 'Client' => @user_token.client }
  end

  test 'get all Subscriptions' do
    get subscriptions_url, headers: @auth_headers, as: :json
    body = JSON.parse(response.body)
    assert_response 200
    body.assert_valid_keys('subscriptions', 'meta')
    body['subscriptions'].first.assert_valid_keys('id', 'created_at', 'user_id' ,'publisher_type', 'publisher_id', 'user_subscription_id', 'publisher_title', 'subscribed')
    assert_equal 3, body['subscriptions'].count
    assert_equal @user.id, body['subscriptions'].first['user_id']
  end

  test 'create Subscription' do
    @rss_channel = rss_channels(:rss_channel_two)
    assert_difference('Subscription.count') do
      post subscriptions_url, params: { subscription: { publisher_type: 'RssChannel', publisher_id: @rss_channel.id } }, headers: @auth_headers, as: :json
    end
    assert_response 201
  end

  test 'don\'t create Subscription if publisher id not valid' do
    assert_no_difference('Subscription.count') do
      post subscriptions_url, params: { subscription: { publisher_type: 'RssChannel', publisher_id: 'not_valid_id' } }, headers: @auth_headers, as: :json
    end
    assert_response 422
  end

  test 'delete Subscription' do
    @subscription = subscriptions(:subscription_one)
    assert_difference('Subscription.count', -1) do
      delete subscription_url(id: @subscription.id), headers: @auth_headers, as: :json
    end
    assert_response 200
  end

  test 'don\'t delete Subscription if it belongs to different user' do
    @subscription = subscriptions(:subscription_four)
    assert_no_difference('Subscription.count') do
      delete subscription_url(id: @subscription.id), headers: @auth_headers, as: :json
    end
    assert_response 404
  end

end
