class Admin::ViewTemplatesController < AdminController
  def index
    @view_templates = @project.view_templates.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @view_templates }
    end
  end

  def new
    @view_template = @project.view_templates.new
  end

  def edit
    @view_template = @project.view_templates.find(params[:id])
  end

  def show
    @view_template = @project.view_templates.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @view_template }
    end
  end

  def create
    @view_template = @project.view_templates.new(params[:view_template])

    respond_to do |format|
      if @view_template.save
        format.html { redirect_to([:admin, @project, @view_template], notice: 'View Template was successfully created.') }
        format.json { render json: @view_template, status: :created, location: @view_template }
      else
        format.html { render action: "new" }
        format.json { render json: @view_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @view_template = @project.view_templates.find(params[:id])

    respond_to do |format|
      if @view_template.update_attributes(params[:view_template])
        format.html { redirect_to [:admin, @project, @view_template], notice: 'View Template was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @view_template.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @view_template = @project.view_templates.find(params[:id])
    @view_template.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_view_templates_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end