class Admin::FeedsController < AdminController
  respond_to :html, :json

  def index
  end

  def new
    @feed = @project.feeds.new
  end

  def edit
    @feed = @project.feeds.find(params[:id])
  end

  def show
    @feed = @project.feeds.find(params[:id])
    respond_with @feed
  end

  def create
    @feed = @project.feeds.new(params[:feed])
    @feed.save
    respond_with @feed, location: [:admin, @project, @feed]
  end

  def update
    @feed = @project.feeds.find(params[:id])
    @feed.update_attributes(params[:feed])
    respond_with @feed, location: [:admin, @project, @feed]
  end

  def destroy
    @feed = @project.feeds.find(params[:id])
    @feed.destroy

    respond_with(@feed, location: admin_project_feeds_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end