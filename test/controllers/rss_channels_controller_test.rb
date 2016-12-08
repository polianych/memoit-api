require 'test_helper'

class RssChannelsControllerTest < ActionDispatch::IntegrationTest

  test 'get RssChannels by category' do
    @rss_category = rss_categories(:rss_category_one)
    get rss_channels_url + "?rss_category_id=#{@rss_category.id}", as: :json
    body = JSON.parse(response.body)
    assert_response 200
    body.assert_valid_keys('rss_channels', 'meta')
    body['meta'].assert_valid_keys('total_pages', 'current_page')
    assert_equal 2, body['rss_channels'].count
  end

  test 'get RssChannels by signed in user' do
    @user = users(:user_one)
    @user_token = UserToken.create(user_id: @user.id)
    @auth_headers = { 'Authorization' => @user_token.token, 'Client' => @user_token.client }
    @rss_category = rss_categories(:rss_category_one)
    get rss_channels_url + "?rss_category_id=#{@rss_category.id}", headers: @auth_headers, as: :json
    body = JSON.parse(response.body)
    assert_equal 1, body['rss_channels'].select {|rc| rc['subscribed']}.count
  end

  test 'get RssChannel by slug' do
    @rss_channel = rss_channels(:rss_channel_two)
    get rss_channel_url(id: @rss_channel.slug), as: :json
    body = JSON.parse(response.body)
    assert_response 200
    body.assert_valid_keys('rss_channel')
    assert_equal body['rss_channel']['id'], @rss_channel.id
    assert_equal body['rss_channel']['slug'], @rss_channel.slug
  end
end
