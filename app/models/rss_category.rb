class RssCategory < ApplicationRecord
  has_many :rss_channels
end
