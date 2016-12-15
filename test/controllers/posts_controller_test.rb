require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
    @user_token = UserToken.create(user_id: @user.id)
    @auth_headers = { 'Authorization' => @user_token.token, 'Client' => @user_token.client }
  end

  test 'return posts by user subscriptions' do
    get posts_url, headers: @auth_headers, as: :json
    body = JSON.parse(response.body)
    assert_response 200
    assert_equal 4, body['posts'].count
    body.assert_valid_keys('posts', 'meta')
    body['meta'].assert_valid_keys('current_page', 'total_pages')
  end

  test 'return posts by user subscriptions and publisher_type' do
    get posts_url + "?publisher_type=RssChannel", headers: @auth_headers, as: :json
    body = JSON.parse(response.body)
    assert_response 200
    assert_equal 1, body['posts'].count
  end

  test 'return posts by publisher_type and publisher_id' do
    @rss_channel = rss_channels(:rss_channel_two)
    get posts_url + "?publisher_type=RssChannel&publisher_id=#{@rss_channel.id}", as: :json
    body = JSON.parse(response.body)
    assert_response 200
    assert_equal 2, body['posts'].count
  end

  test 'creating UserPost' do
    assert_difference 'UserPost.count', 1 do
      post posts_url, headers: @auth_headers, params: { post: { content: 'user post test content' } }, as: :json
    end
    assert_response 201
  end
end
