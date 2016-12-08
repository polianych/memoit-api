require 'test_helper'

class RssChannelsControllerTest < ActionDispatch::IntegrationTest

  test 'get all RssChannels' do
    @rss_category = rss_categories(:rss_category_one)
    get rss_channels_url + "?rss_category_id=#{@rss_category.id}", as: :json
    body = JSON.parse(response.body)
    assert_response 200
    body.assert_valid_keys('rss_channels', 'meta')
    body['meta'].assert_valid_keys('total_pages', 'current_page')
    assert_equal body['rss_channels'].count, 1
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
