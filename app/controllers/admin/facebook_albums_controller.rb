class Admin::FacebookAlbumsController < AdminController
  def index
    @facebook_albums = @project.facebook_albums.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @facebook_albums }
    end
  end

  def new
    @facebook_album = @project.facebook_albums.new
  end

  def edit
    @facebook_album = @project.facebook_albums.find(params[:id])
  end

  def show
    @facebook_album = @project.facebook_albums.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @facebook_album }
    end
  end

  def create
    @facebook_album = @project.facebook_albums.new(params[:facebook_album])

    respond_to do |format|
      if @facebook_album.save
        format.html { redirect_to([:admin, @project, @facebook_album], notice: 'Facebook Album was successfully created.') }
        format.json { render json: @facebook_album, status: :approved }
      else
        format.html { render action: "new" }
        format.json { render json: @facebook_album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @facebook_album = @project.facebook_albums.find(params[:id])

    respond_to do |format|
      if @facebook_album.update_attributes(params[:facebook_album])
        format.html { redirect_to [:admin, @project, @facebook_album], notice: 'Facebook Album was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @facebook_album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @facebook_album = @project.facebook_albums.find(params[:id])
    @facebook_album.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_facebook_albums_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end


  def approve
    @facebook_album = @project.facebook_albums.find(params[:id])
    @facebook_album.approve

    respond_to do |format|
      format.html { redirect_to(admin_project_facebook_albums_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deny
    @facebook_album = @project.facebook_albums.find(params[:id])
    @facebook_album.deny

    respond_to do |format|
      format.html { redirect_to(admin_project_facebook_albums_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end