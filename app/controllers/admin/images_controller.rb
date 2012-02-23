class Admin::ImagesController < AdminController
  def index
    @images = @project.images.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @images }
    end
  end

  def new
    @image = @project.images.new
  end

  def edit
    @image = @project.images.find(params[:id])
  end

  def show
    @image = @project.images.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @image }
    end
  end

  def create
    @image = @project.images.new(params[:image])

    respond_to do |format|
      if @image.save
        @image.move_to_top
        format.html { redirect_to([:admin, @project, @image], notice: 'Image was successfully created.') }
        format.json { render json: @image, status: :approved }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @image = @project.images.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to [:admin, @project, @image], notice: 'Image was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @image = @project.images.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_images_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end


  def approve
    @image = @project.images.find(params[:id])
    @image.approve

    respond_to do |format|
      format.html { redirect_to(admin_project_images_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deny
    @image = @project.images.find(params[:id])
    @image.deny

    respond_to do |format|
      format.html { redirect_to(admin_project_images_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end