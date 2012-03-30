class Api::FeedsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    params[:sort_direction] ||= "asc"
    
    @feeds = @project.feeds
    @feeds = @feeds.order_by(params[:sort_column], params[:sort_direction]) if params[:sort_column]
    @feeds = @feeds.page(params[:page])
    @feeds = @feeds.per(params[:per_page]) if params[:per_page]

    respond_with :api, @project, @feeds
  end

  def show
    @feed = @project.feeds.find_by_name(params[:id])

    respond_with :api, @project, @feed
  end
end