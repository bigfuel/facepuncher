class Api::FacebookEventsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    params[:sort_direction] ||= "asc"
    
    @facebook_events = @project.facebook_events
    @facebook_events = @facebook_events.order_by(params[:sort_column], params[:sort_direction]) if params[:sort_column]
    @facebook_events = @facebook_events.page(params[:page])
    @facebook_events = @facebook_events.per(params[:per_page]) if params[:per_page]

    respond_with :api, @project, @facebook_events
  end

  def show
    @facebook_event = @project.facebook_events.find_by_name(params[:id])

    respond_with :api, @project, @facebook_event
  end
end