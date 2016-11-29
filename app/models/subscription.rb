class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :publisher, polymorphic: true
end
