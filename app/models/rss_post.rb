class RssPost < ApplicationRecord
  has_one :post, as: :postable, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :post
  before_save :parse_content, :parse_media_thumbnail, :parse_video_sources

  def parse_content
    self.post.content = nokogiri_content.xpath("//p/text() | //div/text()").to_s
  end

  def parse_media_thumbnail
    self.media_thumbnail = nokogiri_content.xpath("//img/@src").first.to_s if media_thumbnail.blank?
  end

  def parse_video_sources
    video = nokogiri_content.xpath("//video")
    source_keys = %w{src type}
    return if (video.empty? || post.video_sources.count > 0)
    video.xpath("//source").each do |s|
      next if s.attributes.keys.sort != source_keys
      post.video_sources.build(source_url: s.attributes['src'].to_s, mime_type: s.attributes['type'].to_s)
    end
  end

  def nokogiri_content
    @nokogiri_content ||= Nokogiri::HTML(raw_content)
  end
end
