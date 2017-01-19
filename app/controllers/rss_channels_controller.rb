class RssChannelsController < ApplicationController
  before_action :set_rss_channel, only: [:show]

  def index
    @rss_channels = RssChannel.where( { rss_category_id: params.require(:rss_category_id) } )
                              .order(created_at: :asc)
                              .page(params.fetch(:page, 1))
                              .per(params.fetch(:per_page, Settings.default_per_page))
                              .with_user_subscriptions(current_user)
  end

  def show
    return head :not_found unless @rss_channel
  end

  private
    def set_rss_channel
      @rss_channel = RssChannel.where(slug: params[:id]).with_user_subscriptions(current_user).first
    end
end
