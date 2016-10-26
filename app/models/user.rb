class User < ApplicationRecord
  has_secure_password
  validates_presence_of :email, :uid, :provider, :nickname, :password_digest
  before_validation :set_uid, on: :create


  def set_uid
    update_attribute(:uid, email) if provider == 'email'
  end

  def self.authtenticate_by_token(client, token)
    user_token = UserToken.find_by(client: client)
    return false unless user_token
    user_token.valid_token?(token) ? user_token.user : nil
  end
end
