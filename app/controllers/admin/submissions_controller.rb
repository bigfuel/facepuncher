class Admin::SubmissionsController < AdminController
  def index
    @submissions = @project.submissions.order_by([sort_column, sort_direction]).page(params[:page])

    respond_to do |format|
      format.html
      format.json { render json: @submissions }
    end
  end

  def new
    @submission = @project.submissions.new
  end

  def create
    @submission = @project.submissions.new(params[:submission])

    respond_to do |format|
      if @submission.save
        format.html { redirect_to [:admin, @project, @submission], notice: 'Submission was successfully created.' }
        format.json { render json: @submission, status: :created, location: @submission }
      else
        format.html { render action: "new" }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @submission = @project.submissions.find(params[:id])
  end

  def update
    @submission = @project.submissions.find(params[:id])

    respond_to do |format|
      if @submission.update_attributes(params[:submission])
        format.html { redirect_to [:admin, @project, @submission], notice: 'Submission was successfully updated.' }
        format.json { render json: @submission.as_json(methods: :image_url) }
      else
        format.html { render action: "new" }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @submission = @project.submissions.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @submission }
    end
  end

  def destroy
    @submission = @project.submissions.find(params[:id])
    @submission.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_submissions_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def approve
    @submission = @project.submissions.find(params[:id])
    @submission.approve

    respond_to do |format|
      format.html { redirect_to admin_project_submissions_url(@project) }
      format.json { head :ok }
    end
  end

  def deny
    @submission = @project.submissions.find(params[:id])
    @submission.deny

    respond_to do |format|
      format.html { redirect_to admin_project_submissions_url(@project) }
      format.json { head :ok }
    end
  end
end
