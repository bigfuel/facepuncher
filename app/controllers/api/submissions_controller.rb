class Api::SubmissionsController < ApplicationController
  respond_to :json, :xml

  def index
    @submissions = @project.submissions.page(params[:page])

    respond_with :api, @project, @submissions
  end

  def show
    @submission = @project.submissions.find(params[:id])

    respond_with :api, @project, @submission
  end

  def create
    @submission = @project.submissions.new(params[:submission])
    @submission.save
    respond_with :api, @project, @submission
  end

  def update
    @submission = @project.submissions.find(params[:id])
    @submission.update_attributes(params[:submission])
    respond_with :api, @project, @submission
  end

  def submit
    @submission = Submission.find(params[:id])
    @project = @submission.project
    @submission.submit
    respond_with :api, @project, @submission
  end
end
