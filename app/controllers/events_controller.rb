class EventsController < ApplicationController
  respond_to :json

  def index
    if params[:type]
      types = params[:type].delete_if {|k, v| v == "0"}.keys
      @events = @project.events.future.approved
      if !types.empty?
        @events = @events.any_in(type: types)
      end
    else
      @events = @project.events.future.approved
    end
    respond_with(@events)
  end

  def create
    @event = @project.events.new(params[:event])
    @event.save
    respond_with(@event)
  end
end
