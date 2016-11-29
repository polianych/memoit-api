require 'test_helper'

class RssChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @rss_channel = rss_channels(:one)
  end

  test "should get index" do
    get rss_channels_url, as: :json
    assert_response :success
  end

  test "should create rss_channel" do
    assert_difference('RssChannel.count') do
      post rss_channels_url, params: { rss_channel: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show rss_channel" do
    get rss_channel_url(@rss_channel), as: :json
    assert_response :success
  end

  test "should update rss_channel" do
    patch rss_channel_url(@rss_channel), params: { rss_channel: {  } }, as: :json
    assert_response 200
  end

  test "should destroy rss_channel" do
    assert_difference('RssChannel.count', -1) do
      delete rss_channel_url(@rss_channel), as: :json
    end

    assert_response 204
  end
end
