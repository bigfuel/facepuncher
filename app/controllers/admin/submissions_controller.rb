class Admin::SubmissionsController < AdminController
  respond_to :html, :json

  def index
    @submissions = @project.submissions.order_by([sort_column, sort_direction]).page(params[:page])
    respond_with @submissions
  end

  def new
    @submission = @project.submissions.new
  end

  def create
    @submission = @project.submissions.new(params[:submission])
    @submission.save
    respond_with @submission, location: [:admin, @project, @submission]
  end

  def edit
    @submission = @project.submissions.find(params[:id])
  end

  def update
    @submission = @project.submissions.find(params[:id])
    @submission.update_attributes(params[:submission])
    respond_with @submission, location: [:admin, @project, @submission]
  end

  def show
    @submission = @project.submissions.find(params[:id])
    respond_with @submission
  end

  def destroy
    @submission = @project.submissions.find(params[:id])
    @submission.destroy
    
    respond_with @submission, location: admin_project_submissions_url do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def approve
    @submission = @project.submissions.find(params[:id])
    @submission.approve

    respond_with @submission do |format|
      format.html { redirect_to [:admin, @project, @submission] }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def deny
    @submission = @project.submissions.find(params[:id])
    @submission.deny

    respond_with @submission do |format|
      format.html { redirect_to [:admin, @project, @submission] }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end
