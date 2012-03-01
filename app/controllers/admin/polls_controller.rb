class Admin::PollsController < AdminController
  def index
    @polls = @project.polls.order_by([sort_column, sort_direction])

    respond_to do |format|
      format.html
      format.json { render json: @polls }
    end
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

    respond_to do |format|
      format.html
      format.json { render json: @poll }
    end
  end

  def create
    @poll = @project.polls.new(params[:poll])
    @poll.choices.build(params[:poll][:choices_attributes])

    respond_to do |format|
      if @poll.save
        # hack to fix embedded documents saving images
        # @poll.choices.each_with_index do |c, i|
        #   c.image = params[:poll][:choices_attributes][i]
        #   c.save!
        # end
        @poll.move_to_top
        format.html { redirect_to [:admin, @project, @poll], notice: 'Poll was successfully created.' }
        format.json { render json: @poll }
      else
        # binding.pry
        format.html { render action: "new" }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @poll = @project.polls.find(params[:id])

    respond_to do |format|
      if @poll.update_attributes(params[:poll])
        # hack to fix embedded documents saving images
        # @poll.choices.each_with_index do |c, i|
        #   c.update_attributes!(params[:poll][:choices_attributes][i])
        # end
        format.html { redirect_to [:admin, @project, @poll], notice: 'Poll was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @poll.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @poll = @project.polls.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to admin_project_polls_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def activate
    @poll = @project.polls.find(params[:id])
    @poll.activate

    respond_to do |format|
      format.html { redirect_to admin_project_polls_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end

  def deactivate
    @poll = @project.polls.find(params[:id])
    @poll.deactivate

    respond_to do |format|
      format.html { redirect_to admin_project_polls_url(@project) }
      format.json { render json: '{ "status": "success" }',  status: :ok }
    end
  end
end