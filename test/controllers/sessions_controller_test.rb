require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  test 'should sign in user by email/password' do
    @user = users(:one)
    assert_difference('UserToken.count') do
      post sign_in_url, params: { user: { email: 'test@test.com', password: 'password' } }, as: :json
    end
    assert_response 201
    assert_includes(response.headers.keys, "Authorization")
    assert_includes(response.headers.keys, "Client")
  end

  test 'should sign out user' do
    @user = users(:one)
    @user_token = UserToken.create(user_id: @user.id)
    assert_difference('UserToken.count', -1) do
      delete sign_out_url, headers: { 'Authorization' => @user_token.token, 'Client' => @user_token.client }
    end
    assert_response 200
  end
end
