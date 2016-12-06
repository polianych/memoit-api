class RssChannelsController < ApplicationController
  before_action :set_rss_channel, only: [:show]

  def index
    @rss_channels = RssChannel.all
    @rss_categories = RssCategory.all
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
