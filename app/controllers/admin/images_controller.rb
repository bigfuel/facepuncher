class Admin::ImagesController < AdminController
  respond_to :html, :json

  def index
    @images = @project.images.order_by([sort_column, sort_direction]).page(params[:page])
    respond_with @images
  end

  def new
    @image = @project.images.new
  end

  def edit
    @image = @project.images.find(params[:id])
  end

  def show
    @image = @project.images.find(params[:id])
    respond_with @image
  end

  def create
    @image = @project.images.new(params[:image])
    @image.save
    respond_with @image, location: [:admin, @project, @image]
  end

  def update
    @image = @project.images.find(params[:id])
    @image.update_attributes(params[:image])
    respond_with(@image, location: [:admin, @project, @image])
  end

  def destroy
    @image = @project.images.find(params[:id])
    @image.destroy
    
    respond_with @image, location: admin_project_images_url do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def approve
    @image = @project.images.find(params[:id])
    @image.approve

    respond_with @project do |format|
      format.html { redirect_to [:admin, @project, @image] }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def deny
    @image = @project.images.find(params[:id])
    @image.deny

    respond_with @project do |format|
      format.html { redirect_to [:admin, @project, @image] }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end