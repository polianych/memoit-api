class RssChannelsController < ApplicationController
  before_action :set_rss_channel, only: [:show]

  def index
    @rss_channels = RssChannel.all
    @rss_categories = RssCategory.all
  end

  def show
  end


  private
    def set_rss_channel
      @rss_channel = RssChannel.find(params[:id])
    end
end
