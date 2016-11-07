require 'test_helper'

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest

  test 'should create password reset and send email' do
    perform_enqueued_jobs do
      @user = users(:one)
      assert_difference ['PasswordReset.count', 'ActionMailer::Base.deliveries.size'] do
        post password_resets_url, params: { email: @user.email,
          password_reset_url: 'http://memoit.local/signin/password-resets/%{id}?password_reset_token=%{password_reset_token}' }
      end
      email = ActionMailer::Base.deliveries.last
      assert_includes email.to, @user.email
      assert_includes email.from, 'no-reply@memoit.net'
      assert_equal '[Memoit] Password reset instructions', email.subject
      assert_match("http://memoit.local/signin/password-resets/#{PasswordReset.last.uri}?password_reset_token=", email.html_part.body.to_s)
      assert_response 201
    end
  end

  test 'should successfully update user password' do
    @user = users(:one)
    @password_reset = PasswordReset.create(user: @user)
    assert_difference 'PasswordReset.count', -1 do
      put password_reset_url(id: @password_reset.uri), params: {
                                        password_reset_token: @password_reset.token,
                                        user: {
                                        password: '123456',
                                        password_confirmation: '123456'
                                      } }
    end
    assert_response 200
  end

  test 'show errors when password and password confirmation do not match' do
    @user = users(:one)
    @password_reset = PasswordReset.create(user: @user)
    put password_reset_url(id: @password_reset.uri), params: {
                                        password_reset_token: @password_reset.token,
                                        user: {
                                        password: '123456',
                                        password_confirmation: 'not_match'
                                      } }
    assert_response 422
    body = JSON.parse(response.body)
    assert_includes body['errors_fields']['password_confirmation'], "doesn't match password"
  end

  test 'show errors invalid token' do
    @user = users(:one)
    @password_reset = PasswordReset.create(user: @user)
    put password_reset_url(id: @password_reset.uri), params: {
                                        password_reset_token: 'invalid_token',
                                        user: {
                                        password: '123456',
                                        password_confirmation: '123456'
                                      } }
    assert_response 422
    body = JSON.parse(response.body)
    assert_includes body['errors'], 'Token expired or invalid.'
  end

end
