class FeedsController < ApplicationController
  PER_PAGE = 5

  def index
    feed = @project.feeds.where(name: params[:name]).first
    @response = Hash.new
    entries = []
    entries = RssFeed.get(@project.id, feed.name).take(feed.limit)

    @response[:size] = entries.size

    params[:per_page] ||= PER_PAGE
    if params[:page]
      entries = Kaminari.paginate_array(entries).page(params[:page]).per(params[:per_page])
      @response[:page] = params[:page].to_i
      @response[:per_page] = params[:per_page].to_i
    end

    @response[:entries] = entries

    respond_to do |format|
      format.json { render json: @response }
    end
  end
end