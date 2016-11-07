require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: { user: { email: 'test2@test.com', nickname: 'test2', password: '123456', password_confirmation: '123456' } }, as: :json
    end
    assert_includes response.headers.keys, 'Authorization'
    assert_includes response.headers.keys, 'Client'
    assert_response 201
  end

  test 'show current user' do
    @user = users(:one)
    @user_token = UserToken.create(user_id: @user.id)
    get user_url(id: 'me'), headers: { 'Authorization' => @user_token.token, 'Client' => @user_token.client }, as: :json
    body = JSON.parse(response.body)
    assert_equal body['user']['id'], @user.id
    assert_equal body['user']['email'], @user.email
    assert_response 200
  end

  # test "should show user" do
  #   get user_url(@user), as: :json
  #   assert_response :success
  # end
  #
  # test "should update user" do
  #   patch user_url(@user), params: { user: { email: @user.email, name: @user.name, nickname: @user.nickname, password_digest: @user.password_digest, provider: @user.provider, uid: @user.uid } }, as: :json
  #   assert_response 200
  # end
  #
  # test "should destroy user" do
  #   assert_difference('User.count', -1) do
  #     delete user_url(@user), as: :json
  #   end
  #
  #   assert_response 204
  # end
end
