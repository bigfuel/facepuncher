class Admin::PostsController < AdminController
  def index
    @posts = @project.posts.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @posts }
    end
  end

  def new
    @post = @project.posts.new
  end

  def edit
    @post = @project.posts.find(params[:id])
  end

  def show
    @post = @project.posts.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @post }
    end
  end

  def create
    @post = @project.posts.new(params[:post])

    respond_to do |format|
      if @post.save
        @post.move_to_top
        format.html { redirect_to([:admin, @project, @post], notice: 'Post was successfully created.') }
        format.json { render json: @post}
      else
        format.html { render action: "new" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @post = @project.posts.find(params[:id])

    respond_to do |format|
      # Hack to fix mongoid not updating embedded objects with the parent
      if @post.update_attributes(params[:post])
        format.html { redirect_to [:admin, @project, @post], notice: 'Post was successfully updated.' }
        format.json { render json: @post }
      else
        format.html { render action: "edit" }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = @project.posts.find(params[:id])
    @post.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_posts_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def approve
    @post = @project.posts.find(params[:id])
    @post.approve

    respond_to do |format|
      format.html { redirect_to(admin_project_posts_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deny
    @post = @project.posts.find(params[:id])
    @post.deny

    respond_to do |format|
      format.html { redirect_to(admin_project_posts_url(@project)) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def up
    @post = @project.posts.find(params[:id])
    @post.move(:up)

    respond_to do |format|
      format.html { redirect_to admin_project_posts_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def down
    @post = @project.posts.find(params[:id])
    @post.move(:down)

    respond_to do |format|
      format.html { redirect_to admin_project_posts_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end