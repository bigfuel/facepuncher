class Admin::FacebookAlbumsController < AdminController
  respond_to :html, :json

  def index
  end

  def new
    @facebook_album = @project.facebook_albums.new
  end

  def edit
    @facebook_album = @project.facebook_albums.find(params[:id])
  end

  def show
    @facebook_album = @project.facebook_albums.find(params[:id])
    respond_with @facebook_album
  end

  def create
    @facebook_album = @project.facebook_albums.new(params[:facebook_album])
    @facebook_album.save
    respond_with @facebook_album, location: [:admin, @project, @facebook_album]
  end

  def update
    @facebook_album = @project.facebook_albums.find(params[:id])
    @facebook_album.update_attributes(params[:facebook_album])
    respond_with @facebook_album, location: [:admin, @project, @facebook_album]
  end

  def destroy
    @facebook_album = @project.facebook_albums.find(params[:id])
    @facebook_album.destroy

    respond_with(@facebook_album, location: admin_project_facebook_albums_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end