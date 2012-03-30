class Admin::FacebookEventsController < AdminController
  respond_to :html, :json

  def index
  end

  def new
    @facebook_event = @project.facebook_events.new
  end

  def edit
    @facebook_event = @project.facebook_events.find_by_name(params[:id])
  end

  def show
  end

  def create
    @facebook_event = @project.facebook_events.new(params[:facebook_event])
    @facebook_event.save
    respond_with @facebook_event, location: [:admin, @project, @facebook_event]
  end

  def update
    @facebook_event = @project.facebook_events.find_by_name(params[:id])
    @facebook_event.update_attributes(params[:facebook_event])
    respond_with @facebook_event, location: [:admin, @project, @facebook_event]
  end

  def destroy
    @facebook_event = @project.facebook_events.find_by_name(params[:id])
    @facebook_event.destroy

    respond_with(@facebook_event, location: admin_project_facebook_events_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end