class Admin::ReleasesController < AdminController
  def index
    @releases = @project.releases.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @releases }
    end
  end

  def show
    @release = @project.releases.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @release }
    end
  end

  def new
    @release = @project.releases.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @release }
    end
  end

  def edit
    @release = @project.releases.find(params[:id])
  end

  def create
    @release = @project.releases.new(params[:release])

    respond_to do |format|
      if @release.save
        format.html { redirect_to admin_project_releases_url(@project), notice: 'Release was successfully created.' }
        format.json { render json: @release, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @release = @project.releases.find(params[:id])

    respond_to do |format|
      if @release.update_attributes(params[:release])
        format.html { redirect_to admin_project_releases_url(@project), notice: 'Release was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @release = @project.releases.find(params[:id])
    @release.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_releases_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def go_live
    @release = @project.releases.find(params[:id]).dup
    @release.description = "Redeploy #{@release.branch} branch"
    @release.live_date = Time.current
    @release.status = ""
    @release.save
    @project.touch
    Resque.enqueue(DeployProject, @project.name)

    respond_to do |format|
      format.html { redirect_to(admin_project_releases_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end