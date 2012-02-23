class Admin::FeedsController < AdminController
  def index
    @feeds = @project.feeds.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @feeds }
    end
  end

  def new
    @feed = @project.feeds.new
  end

  def edit
    @feed = @project.feeds.find(params[:id])
  end

  def show
    @feed = @project.feeds.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @feed }
    end
  end

  def create
    @feed = @project.feeds.new(params[:feed])

    respond_to do |format|
      if @feed.save
        @feed.move_to_top
        format.html { redirect_to([:admin, @project, @feed], notice: 'Feed was successfully created.') }
        format.json { render json: @feed, status: :created, location: @feed }
      else
        format.html { render action: "new" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @feed = @project.feeds.find(params[:id])

    respond_to do |format|
      if @feed.update_attributes(params[:feed])
        format.html { redirect_to [:admin, @project, @feed], notice: 'Feed was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @feed = @project.feeds.find(params[:id])
    @feed.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_feeds_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end