class User < ApplicationRecord
  include JoinUserSubscription

  attr_accessor             :current_password, :validate_password
  alias                     :validate_password? :validate_password
  has_secure_password       validations: false

  validates_presence_of     :uid, :provider, :nickname
  validates_uniqueness_of   :uid, scope: :provider
  validates_presence_of     :email, if: lambda { |m| m.provider == 'email' }
  validates_uniqueness_of   :email, :message => Proc.new { |error, attributes| "has already taken#{(p = User.find_by(email: attributes[:value]).try(:provider)) != 'email' ? ". Provider: #{p}" : ''}"}, allow_blank: true
  validates_format_of       :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, allow_blank: true
  validates_uniqueness_of   :nickname
  validates_format_of       :nickname, :with => /\A[a-zA-Z][\w\d]*\z/, message: "only letters, numbers and undersoce"
  validates                 :nickname, exclusion: { in: %w(me), message: "%{value} is reserved" }
  validates_length_of       :password, :minimum => 6, if: lambda { |m| m.provider == 'email' && m.password.present? }
  validates_presence_of     :password, :on => :create, if: lambda { |m| m.provider == 'email' }
  validates_presence_of     :password, :on => :update, if: :validate_password?
  validates_confirmation_of :password, if: lambda { |m| m.provider == 'email' && m.password.present? }, :message => Proc.new { |error, attributes| "doesn't match password" }
  validates_presence_of     :password_confirmation, if: lambda { |m| m.provider == 'email' && m.password.present? }
  validate                  :current_password_is_correct, if: :validate_password?, on: :update
  validates_presence_of     :current_password, if: :validate_password?, on: :update

  before_validation         :set_uid, on: :create
  after_create              :create_self_subscription
  has_many  :user_tokens,           dependent: :destroy
  has_one   :password_reset,        dependent: :destroy
  has_many  :posts, as: :publisher, dependent: :destroy
  has_many  :subscriptions,         dependent: :destroy


  def current_password_is_correct
    if User.find(id).authenticate(current_password) == false
      errors.add(:current_password, "is incorrect.")
    end
  end

  def set_uid
    self.uid = email if provider == 'email'
  end

  def create_self_subscription
    Subscription.create(publisher: self, user: self)
  end

  def self.authtenticate_by_token(client, token)
    user_token = UserToken.find_by(client: client)
    return false unless user_token
    user_token.valid_token?(token) ? user_token.user : nil
  end

  def self.search(query)
    query = query.downcase
    where("nickname ILIKE ?", "%#{query}%").or(where("name ILIKE ?", "%#{query}%"))
  end
end
