require 'csv'

class Admin::EventsController < AdminController
  def index
    @events = @project.events.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @events }
    end
  end

  def new
    @event = @project.events.new
    @event.build_location
    @start_lat, @start_lng = 40.742264, -73.99134079999999
  end

  def edit
    @event = @project.events.find(params[:id])
    @start_lat, @start_lng = @event.location.latitude, @event.location.longitude
  end

  def show
    @event = @project.events.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @event }
    end
  end

  def create
    @event = @project.events.new(params[:event])

    respond_to do |format|
      if @event.save
        @event.move_to_top
        format.html { redirect_to([:admin, @project, @event], notice: 'Event was successfully created.') }
        format.json { render json: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event = @project.events.find(params[:id])

    respond_to do |format|
      # Hack to fix mongoid not updating embedded objects with the parent
      if @event.update_attributes(params[:event]) && @event.location.update_attributes(params[:event][:location_attributes])
        format.html { redirect_to [:admin, @project, @event], notice: 'Event was successfully updated.' }
        format.json { render json: @event }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = @project.events.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_events_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def approve
    @event = @project.events.find(params[:id])
    @event.approve

    respond_to do |format|
      format.html { redirect_to(admin_project_events_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deny
    @event = @project.events.find(params[:id])
    @event.deny

    respond_to do |format|
      format.html { redirect_to(admin_project_events_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def import
    logger.debug params[:file].open
    CSV.parse(params[:file].open, {headers: true}) do |row|
      @project.events.create!(name: row['name'], type: row['type'], start_date: Date.strptime(row['start_date'], '%m/%d/%Y'), end_date: Date.strptime(row['end_date'], '%m/%d/%Y'), url: row['url'], details: row['details'], location: Location.new(name: row['location.name'], address: row['location.address'], latitude: row['location.latitude'] || 0, longitude: row['location.longitude'] || 0))
    end
    redirect_to(admin_project_events_url(@project))
  end
end