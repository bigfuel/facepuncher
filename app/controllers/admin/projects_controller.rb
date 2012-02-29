class Admin::ProjectsController < AdminController
  def index
    @projects = Project.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @projects }
    end
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.where(name: params[:id]).first
  end

  def show
    @project = Project.where(name: params[:id]).first

    respond_to do |format|
      format.html
      format.json { render json: @project }
    end
  end

  def create
    @project = Project.new(params[:project])

    respond_to do |format|
      if @project.save
        format.html { redirect_to([:admin, @project], notice: 'Project was successfully created.') }
        format.json { render json: @project }
      else
        format.html { render action: "new" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @project = Project.where(name: params[:id]).first

    respond_to do |format|
      if @project.update_attributes(params[:project])
        format.html { redirect_to([:admin, @project], notice: 'Project was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project = Project.where(name: params[:id]).first
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(admin_projects_url) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def activate
    @project = Project.where(name: params[:id]).first
    @project.activate

    respond_to do |format|
      format.html { redirect_to(admin_projects_url) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deactivate
    @project = Project.where(name: params[:id]).first
    @project.deactivate

    respond_to do |format|
      format.html { redirect_to(admin_projects_url) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def queue_deploy
    DeployProject.queue_active

    respond_to do |format|
      format.html { redirect_to(admin_projects_url) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end
