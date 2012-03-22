class Admin::PollsController < AdminController
  respond_to :html, :json

  def index
  end

  def new
    @poll = @project.polls.new
    2.times { @poll.choices.build }
  end

  def edit
    @poll = @project.polls.find(params[:id])
  end

  def show
    @poll = @project.polls.find(params[:id])
    respond_with @poll
  end

  def create
    @poll = @project.polls.new(params[:poll])
    @poll.save
    respond_with @poll, location: [:admin, @project, @poll]
  end

  def update
    @poll = @project.polls.find(params[:id])
    @poll.update_attributes(params[:poll])
    respond_with @poll, location: [:admin, @project, @poll]
  end

  def destroy
    @poll = @project.polls.find(params[:id])
    @poll.destroy

    respond_with @poll, location: admin_project_polls_url do |format|
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def activate
    @poll = @project.polls.find(params[:id])
    @poll.activate

    respond_with @poll do |format|
      format.html { redirect_to [:admin, @project, @poll] }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end

  def deactivate
    @poll = @project.polls.find(params[:id])
    @poll.deactivate

    respond_with @poll do |format|
      format.html { redirect_to [:admin, @project, @poll] }
      format.json { render json: '{ "status":"success" }', status: :ok }
    end
  end
end