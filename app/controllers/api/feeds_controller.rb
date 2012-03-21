class Api::FeedsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml
  PER_PAGE = 5

  def show
    feed = @project.feeds.where(name: params[:id]).first
    @response = Hash.new
    entries = RssFeed.get(@project.name, feed.name) || []
    entries = entries.take(feed.limit)

    @response[:size] = entries.size

    params[:per_page] ||= PER_PAGE
    if params[:page]
      entries = Kaminari.paginate_array(entries).page(params[:page]).per(params[:per_page])
      @response[:page] = params[:page].to_i
      @response[:per_page] = params[:per_page].to_i
    end

    @response[:entries] = entries

    respond_with @response
  end
end