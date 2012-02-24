class EventsController < ApplicationController
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
    respond_to do |format|
      format.json { render json: @events }
    end
  end

  def create
    @event = @project.events.new(params[:event])
    @event.build_location(params[:event][:location_attributes])

    respond_to do |format|
      if @event.save
        format.json { render json: @event }
      else
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end
end
