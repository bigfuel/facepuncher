class Admin::VideosController < AdminController
  def index
    @videos = @project.videos.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @videos }
    end
  end

  def new
    @video = @project.videos.new
  end

  def edit
    @video = @project.videos.find(params[:id])
  end

  def show
    @video = @project.videos.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @video }
    end
  end

  def create
    @video = @project.videos.new(params[:video])

    respond_to do |format|
      if @video.save
        @video.move_to_top
        format.html { redirect_to([:admin, @project, @video], notice: 'Video was successfully created.') }
        format.json { render json: @submission, status: :created, location: @video }
      else
        format.html { render action: "new" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @video = @project.videos.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to [:admin, @project, @video], notice: 'Video was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @video = @project.videos.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_videos_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def approve
    @video = @project.videos.find(params[:id])
    @video.approve

    respond_to do |format|
      format.html { redirect_to(admin_project_videos_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deny
    @video = @project.videos.find(params[:id])
    @video.deny

    respond_to do |format|
      format.html { redirect_to(admin_project_videos_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end