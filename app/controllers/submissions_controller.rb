class SubmissionsController < ApplicationController
  respond_to :json

  def create
    @submission = @project.submissions.new(params[:submission])
    @submission.save
    respond_with @project, @submission
  end

  def update
    @submission = @project.submissions.find(params[:id])
    @submission.update_attributes(params[:submission])
    respond_with @project, @submission
  end

  def submit
    @submission = Submission.find(params[:id])
    @project = @submission.project
    @submission.submit
    respond_with @project, @submission
  end
end
