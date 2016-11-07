require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'send password reset instructions' do
    email = UserMailer.password_reset_instructions('test_reset_password@test.com',
                                                   'http://memoit.local/reset_password_url')
    assert_emails 1 do
      email.deliver_now
    end

    assert_includes email.to, 'test_reset_password@test.com'
    assert_includes email.from, 'no-reply@memoit.net'
    assert_equal '[Memoit] Password reset instructions', email.subject
    assert_equal read_fixture('password_reset_instructions.txt').join + "\n", email.text_part.body.to_s
    assert_equal read_fixture('password_reset_instructions.html').join, email.html_part.body.to_s
  end
end
