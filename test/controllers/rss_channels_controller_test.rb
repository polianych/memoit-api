require 'test_helper'

class RssChannelsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @rss_channel = rss_channels(:one)
    @rss_category = rss_categories(:one)
  end

  test 'get all RssChannels' do
    get rss_channels_url, as: :json
    body = JSON.parse(response.body)
    body.assert_valid_keys('rss_categories', 'rss_channels')
    assert_equal body['rss_channels'].count, 2
    assert_equal body['rss_categories'].count, 2
    assert_response 200
  end

  test 'get RssChannel by slug' do
    get rss_channel_url(id: @rss_channel.slug), as: :json
    body = JSON.parse(response.body)
    body.assert_valid_keys('rss_channel')
    assert_equal body['rss_channel']['id'], @rss_channel.id
    assert_equal body['rss_channel']['slug'], @rss_channel.slug
    assert_response 200
  end
end
