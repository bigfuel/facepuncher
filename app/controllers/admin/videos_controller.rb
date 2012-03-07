class Admin::VideosController < AdminController
  respond_to :html, :json

  def index
    @videos = @project.videos.order_by([sort_column, sort_direction]).page(params[:page])
    respond_with(@videos)
  end

  def new
    @video = @project.videos.new
  end

  def edit
    @video = @project.videos.find(params[:id])
  end

  def show
    @video = @project.videos.find(params[:id])
    respond_with(@video)
  end

  def create
    @video = @project.videos.new(params[:video])
    @video.save
    respond_with(@video, location: [:admin, @project, @video])
  end

  def update
    @video = @project.videos.find(params[:id])
    @video.update_attributes(params[:video])
    respond_with(@video, location: [:admin, @project, @video])
  end

  def destroy
    @video = @project.videos.find(params[:id])
    @video.destroy
    respond_with(@signup, location: admin_project_videos_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def approve
    @video = @project.videos.find(params[:id])
    @video.approve
    respond_with(@project) do |format|
      format.html { redirect_to admin_project_videos_url }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def deny
    @video = @project.videos.find(params[:id])
    @video.deny
    respond_with(@project) do |format|
      format.html { redirect_to admin_project_videos_url }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end