class Api::FacebookEventsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    @facebook_events = @project.facebook_events.page(params[:page])

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