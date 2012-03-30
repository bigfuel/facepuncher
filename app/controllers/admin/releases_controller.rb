class Admin::ReleasesController < AdminController
  def index
    @releases = @project.releases.page(params[:page])
    respond_with @releases
  end

  def new
    @release = @project.releases.new
  end

  def edit
    @release = @project.releases.find(params[:id])
  end

  def show
    @release = @project.releases.find(params[:id])
    respond_with @release
  end

  def create
    @release = @project.releases.new(params[:release])
    @release.save
    respond_with @release, location: [:admin, @project, @release]
  end

  def update
    @release = @project.releases.find(params[:id])
    @release.update_attributes(params[:release])
    respond_with @release, location: [:admin, @project, @release]
  end

  def destroy
    @release = @project.releases.find(params[:id])
    @release.destroy

    respond_with(@release, location: admin_project_releases_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def go_live
    @release = @project.releases.find(params[:id]).dup
    @release.description = "Redeploy #{@release.branch} branch"
    @release.live_date = Time.current
    @release.status = ""
    @release.save
    @project.touch
    DeployProject.perform_async @project.name

    respond_with(@release) do |format|
      format.html { redirect_to(admin_project_releases_url(@project)) }
      format.json { render json: '{ "status":"success" }',status: :ok }
    end
  end
end