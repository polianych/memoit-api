class RssChannelsController < ApplicationController
  before_action :set_rss_channel, only: [:show]

  def index
    @rss_channels = RssChannel.with_user_subscriptions( { rss_category_id: params.require(:rss_category_id) }, current_user).page(params.fetch(:page, 1)).per(10)
  end

  def show
    return head :not_found unless @rss_channel
  end

  private
    def set_rss_channel
      @rss_channel = RssChannel.with_user_subscriptions( { slug: params[:id] }, current_user).first
    end
end
