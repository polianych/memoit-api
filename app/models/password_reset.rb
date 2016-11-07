class PasswordReset < ApplicationRecord
  include Uriable

  belongs_to :user
  before_validation :generate_token

  attr_accessor :token

  def generate_token
    self.token      = Uriable.generate_random_token
    self.token_hash = ::BCrypt::Password.create(token)
    self.expiry     = 1.day.from_now
  end

  def valid_token?(token)
    ::BCrypt::Password.new(self.token_hash) == token && expiry > Time.now
  end

  def send_password_reset_instructions(url_template)
    UserMailer.reset_password_inctructions(self, url_template).deliver_later
  end

  def generate_url(url_template)
    url_template % { password_reset_token: token, id: uri }
  end
end
