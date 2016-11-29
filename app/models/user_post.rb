class UserPost < ApplicationRecord
  has_one :post, as: :postable, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :post
end
