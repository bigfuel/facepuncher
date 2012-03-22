class Admin::PostsController < AdminController
  respond_to :html, :json

  def index
  end

  def new
    @post = @project.posts.new
  end

  def edit
    @post = @project.posts.find(params[:id])
  end

  def show
  end

  def create
    @post = @project.posts.new(params[:post])
    @post.save
    respond_with @post, location: [:admin, @project, @post]
  end

  def update
    @post = @project.posts.find(params[:id])
    @post.update_attributes(params[:post])
    respond_with @post, location: [:admin, @project, @post]
  end

  def destroy
    @post = @project.posts.find(params[:id])
    @post.destroy

    respond_with(@post, location: admin_project_posts_url) do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def approve
    @post = @project.posts.find(params[:id])
    @post.approve

    respond_with(@project) do |format|
      format.html { redirect_to admin_project_posts_url }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def deny
    @post = @project.posts.find(params[:id])
    @post.deny

    respond_with(@project) do |format|
      format.html { redirect_to admin_project_posts_url }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end