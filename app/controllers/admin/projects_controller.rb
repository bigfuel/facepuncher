class Admin::ProjectsController < AdminController
  respond_to :html, :json, except: :queue_deploy

  def index
    @projects = Project.order_by([sort_column, sort_direction]).page(params[:page])
    respond_with @projects
  end

  def new
    @project = Project.new
  end

  def edit
    @project = Project.find_by_name(params[:id])
  end

  def show
    @project = Project.find_by_name(params[:id])
    respond_with @project
  end

  def create
    @project = Project.new(params[:project])
    @project.save
    respond_with @project, location: [:admin, @project]
  end

  def update
    @project = Project.find_by_name(params[:id])
    @project.update_attributes(params[:project])
    respond_with @project, location: [:admin, @project]
  end

  def destroy
    @project = Project.find_by_name(params[:id])
    @project.destroy

    respond_with @project, location: admin_projects_url do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def activate
    @project = Project.find_by_name(params[:id])
    @project.activate

    respond_with @project do |format|
      format.html { redirect_to admin_projects_url }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def deactivate
    @project = Project.find_by_name(params[:id])
    @project.deactivate

    respond_with @project do |format|
      format.html { redirect_to admin_projects_url }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def queue_deploy
    DeployProject.queue_active

    respond_with @project, location: admin_projects_url do |format|
      format.json { render json: '{ "status":"success" }',  status: :ok }
    end
  end
end
