class Admin::FacebookEventsController < AdminController
  def index
    @facebook_events = @project.facebook_events.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @facebook_events }
    end
  end

  def new
    @facebook_event = @project.facebook_events.new
  end

  def edit
    @facebook_event = @project.facebook_events.find(params[:id])
  end

  def show
    @facebook_event = @project.facebook_events.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @facebook_event }
    end
  end

  def create
    @facebook_event = @project.facebook_events.new(params[:facebook_event])

    respond_to do |format|
      if @facebook_event.save
        format.html { redirect_to([:admin, @project, @facebook_event], notice: 'Facebook Event was successfully created.') }
        format.json { render json: @facebook_event, status: :approved }
      else
        format.html { render action: "new" }
        format.json { render json: @facebook_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @facebook_event = @project.facebook_events.find(params[:id])

    respond_to do |format|
      if @facebook_event.update_attributes(params[:facebook_event])
        format.html { redirect_to [:admin, @project, @facebook_event], notice: 'Facebook Event was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @facebook_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @facebook_event = @project.facebook_events.find(params[:id])
    @facebook_event.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_facebook_events_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end


  def approve
    @facebook_event = @project.facebook_events.find(params[:id])
    @facebook_event.approve

    respond_to do |format|
      format.html { redirect_to(admin_project_facebook_events_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deny
    @facebook_event = @project.facebook_events.find(params[:id])
    @facebook_event.deny

    respond_to do |format|
      format.html { redirect_to(admin_project_facebook_events_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end