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
    @response = FacebookGraph::Event.get(@project.id)

    respond_with @response
  end

  def create
    @facebook_event = @project.facebook_events.new(params[:facebook_event])
    @facebook_event.save
    
    respond_with :api, @project, @facebook_event
  end
end