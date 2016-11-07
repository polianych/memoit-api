class UserMailer < ApplicationMailer
  default from: 'no-reply@memoit.net'

  def password_reset_instructions(email, password_reset_url)
    @password_reset_url = password_reset_url
    mail(to: email, subject: '[Memoit] Password reset instructions')
  end
end
