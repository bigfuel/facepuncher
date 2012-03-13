class Admin::ViewTemplatesController < AdminController
  def index
    @view_templates = @project.view_templates.order_by([sort_column, sort_direction]).page(params[:page])
    respond_with @view_templates
  end

  def new
    @release = @project.view_templates.new
  end

  def edit
    @release = @project.view_templates.find(params[:id])
  end

  def show
    @release = @project.view_templates.find(params[:id])
    respond_with @release
  end

  def create
    @release = @project.view_templates.new(params[:release])
    @release.save
    respond_with @release, location: [:admin, @project, @release]
  end

  def update
    @release = @project.view_templates.find(params[:id])
    @release.update_attributes(params[:release])
    respond_with @release, location: [:admin, @project, @release]
  end

  def destroy
    @release = @project.view_templates.find(params[:id])
    @release.destroy

    respond_with(@release, location: admin_project_view_templates_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end