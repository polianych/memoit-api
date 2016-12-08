class RssChannelsController < ApplicationController
  before_action :set_rss_channel, only: [:show]

  def index
    @rss_channels = RssChannel.where(rss_category_id: params.require(:rss_category_id)).page(params.fetch(:page, 1)).per(10)
    @rss_channels_ids = @rss_channels.pluck(:id)
    @subscribed_ids = user_signed_in? ? current_user.subscriptions.where(publisher_type: 'RssChannel', publisher_id: @rss_channels_ids).pluck(:publisher_id) & @rss_channels_ids : []
  end

  def show
    if !@rss_channel
      head :not_found
    else
      @subscribed_ids = user_signed_in? ? current_user.subscriptions.where(publisher_type: 'RssChannel', publisher_id: @rss_channel.id).pluck(:publisher_id) & [@rss_channel.id] : []
    end
  end


  private
    def set_rss_channel
      @rss_channel = RssChannel.find_by(slug: params[:id])
    end
end
