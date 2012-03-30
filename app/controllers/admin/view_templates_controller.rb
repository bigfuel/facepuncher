class Admin::ViewTemplatesController < AdminController
  def index
    @view_templates = @project.view_templates.page(params[:page])
    respond_with @view_templates
  end

  def new
    @view_template = @project.view_templates.new
  end

  def edit
    @view_template = @project.view_templates.find(params[:id])
  end

  def show
    @view_template = @project.view_templates.find(params[:id])
    respond_with @view_template
  end

  def create
    @view_template = @project.view_templates.new(params[:view_template])
    @view_template.save
    respond_with @view_template, location: [:admin, @project, @view_template]
  end

  def update
    @view_template = @project.view_templates.find(params[:id])
    @view_template.update_attributes(params[:view_template])
    respond_with @view_template, location: [:admin, @project, @view_template]
  end

  def destroy
    @view_template = @project.view_templates.find(params[:id])
    @view_template.destroy

    respond_with(@view_template, location: admin_project_view_templates_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end