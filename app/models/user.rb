class User < ApplicationRecord
  has_secure_password       validations: false

  validates_presence_of     :uid, :provider, :nickname
  validates_uniqueness_of   :uid, scope: :provider
  validates_presence_of     :email, if: lambda { |m| m.provider == 'email' }
  validates_uniqueness_of   :email, :message => Proc.new { |error, attributes| "has already taken#{(p = User.find_by(email: attributes[:value]).try(:provider)) != 'email' ? ". Provider: #{p}" : ''}"}, allow_blank: true
  validates_format_of       :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true
  validates_uniqueness_of   :nickname, message: "only letters, numbers and undersoce"
  validates_format_of       :nickname, :with => /\A[a-zA-Z][\w\d]*\z/
  validates                 :nickname, exclusion: { in: %w(me), message: "%{value} is reserved" }
  validates_length_of       :password, :minimum => 6, if: lambda { |m| m.provider == 'email' && m.password.present? }
  validates_presence_of     :password, :on => :create, if: lambda { |m| m.provider == 'email' }
  validates_confirmation_of :password, if: lambda { |m| m.provider == 'email' && m.password.present? }, :message => Proc.new { |error, attributes| "doesn't match password" }
  validates_presence_of     :password_confirmation, if: lambda { |m| m.provider == 'email' && m.password.present? }

  before_validation         :set_uid, on: :create
  has_many  :user_tokens,           dependent: :destroy
  has_one   :password_reset,        dependent: :destroy
  has_many  :posts, as: :publisher, dependent: :destroy
  has_many  :subscriptions,         dependent: :destroy

  def set_uid
    self.uid = email if provider == 'email'
  end

  def self.authtenticate_by_token(client, token)
    user_token = UserToken.find_by(client: client)
    return false unless user_token
    user_token.valid_token?(token) ? user_token.user : nil
  end
end
