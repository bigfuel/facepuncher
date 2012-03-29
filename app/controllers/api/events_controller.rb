class Api::EventsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    params[:sort_direction] ||= "asc"
    
    @events = @project.events
    @events = @events.where(state: params[:state]) if params[:state]
    @events = @events.any_in(type: params[:type].split(",")) if params[:type]
    @events = @events.order_by(params[:sort_column], params[:sort_direction]) if params[:sort_column]
    @events = @events.page(params[:page])
    @events = @events.per(params[:per_page]) if params[:per_page]
    
    respond_with :api, @project, @events
  end

  def show
    @event = @project.events.find(params[:id])

    respond_with :api, @project, @event
  end
end
