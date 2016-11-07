class UserMailer < ApplicationMailer
  default from: 'no-reply@memoit.net'

  def reset_password_inctructions(reset_password, url_template)
    @reset_password_url = reset_password.generate_url(url_template)
    mail(to: reset_password.user.email, subject: 'Password reset request for Memoit')
  end
end
