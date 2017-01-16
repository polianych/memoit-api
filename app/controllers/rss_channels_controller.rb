class RssChannelsController < ApplicationController
  before_action :set_rss_channel, only: [:show]

  def index
    @rss_channels = RssChannel.with_user_subscriptions( current_user, { rss_category_id: params.require(:rss_category_id) } ).page(params.fetch(:page, 1)).per(10)
  end

  def show
    return head :not_found unless @rss_channel
  end

  private
    def set_rss_channel
      @rss_channel = RssChannel.with_user_subscriptions( current_user, { slug: params[:id] } ).first
    end
end
