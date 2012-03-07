class Api::EventsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    if params[:type]
      types = params[:type].delete_if {|k, v| v == "0"}.keys
      @events = @project.events.approved
      if !types.empty?
        @events = @events.any_in(type: types)
      end
      @events.page(params[:page])
    else
      @events = @project.events.approved.page(params[:page])
    end
    respond_with :api, @project, @events
  end

  def show
    @event = @project.events.approved.find(params[:id])
    respond_with :api, @project, @event
  end

  def create
    @event = @project.events.new(params[:event])
    @event.save
    respond_with :api, @project, @event
  end
end
