class RssChannelsController < ApplicationController
  before_action :set_rss_channel, only: [:show]

  def index
    @rss_channels = RssChannel.where(rss_category_id: params.require(:rss_category_id)).page(params.fetch(:page, 1)).per(10)
  end

  def show
    if !@rss_channel
      head :not_found
    end
  end


  private
    def set_rss_channel
      @rss_channel = RssChannel.find_by(slug: params[:id])
    end
end
