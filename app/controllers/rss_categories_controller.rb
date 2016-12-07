class RssCategoriesController < ApplicationController

  before_action :set_rss_category, only: [:show]

  def index
    @rss_categories = RssCategory.all
  end

  def show
    if !@rss_category
      head :not_found
    end
  end


  private
    def set_rss_category
      @rss_category = RssCategory.find(params[:id])
    end
end
