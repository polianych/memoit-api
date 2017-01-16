require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
  end

  test 'search users by query' do
    @user_token = UserToken.create(user_id: @user.id)
    get users_url + "?search_query=search", headers: { 'Authorization' => @user_token.token, 'Client' => @user_token.client }, as: :json
    body = JSON.parse(response.body)
    body.assert_valid_keys("users", "meta")
    body['meta'].assert_valid_keys("current_page", "total_pages")
    body['users'].first.assert_valid_keys("id", "nickname", "name", "email", "uid", "provider", "created_at", "updated_at", "subscribed", "user_subscription_id")
    assert_equal body['users'].count, 1
    assert_response 200
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: { user: { email: 'test2@test.com', nickname: 'test2', password: '123456', password_confirmation: '123456' } }, as: :json
    end
    assert_response 201
    assert_includes response.headers.keys, 'Authorization'
    assert_includes response.headers.keys, 'Client'
  end

  test 'show current user' do
    @user_token = UserToken.create(user_id: @user.id)
    get user_url(id: 'me'), headers: { 'Authorization' => @user_token.token, 'Client' => @user_token.client }, as: :json
    body = JSON.parse(response.body)
    assert_response 200
    assert_equal body['user']['id'], @user.id
    assert_equal body['user']['email'], @user.email
  end

  test 'show user by nickname as params[:id]' do
    get user_url(id: @user.nickname), as: :json
    body = JSON.parse(response.body)
    assert_response 200
    assert_equal body['user']['id'], @user.id
    assert_equal body['user']['email'], @user.email
  end

  test 'show not found when no user with such nickname' do
    get user_url(id: 'not_found'), as: :json
    assert_response 404
  end

  test 'show forbidden when try get current user without valid authorization headers' do
    get user_url(id: 'me'), headers: { 'Authorization' => 'not_valid_token', 'Client' => 'not_valid_client' }, as: :json
    assert_response 401
  end

end
