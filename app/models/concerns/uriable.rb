module Uriable
  extend ActiveSupport::Concern

  included do
    validates_uniqueness_of :uri
    validates_presence_of   :uri
    before_validation(on: :create) do
      self.uri = loop do
        uri = Uriable.generate_random_token
        break uri unless self.class.exists?(uri: uri)
      end
    end
  end

  def self.generate_random_token
    SecureRandom.base58(24)
  end
end
