class UserToken < ApplicationRecord
  belongs_to :user
  validates_presence_of :user_id, :client, :expiry, :token_hash
  validates_uniqueness_of :client, scope: :user

  before_validation :set_values, on: :create
  attr_accessor :token

  def set_values
    self.client     ||= self.class.generate_token
    self.expiry     ||= 3.month.from_now
    self.token        = self.class.generate_token
    self.token_hash ||= ::BCrypt::Password.create(token)
  end

  def valid_token?(token)
    ::BCrypt::Password.new(self.token_hash) == token && expiry > Time.now
  end

  def self.generate_token
    SecureRandom.urlsafe_base64(24).tr('lIO0', 'sxyz')
  end

  def self.destroy_expired(user)
    where(['expiry < ? AND user_id = ?', DateTime.now, user.id]).destroy_all
  end

end
