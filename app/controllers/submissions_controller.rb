class SubmissionsController < ApplicationController
  def create
    @submission = @project.submissions.new(params[:submission])
    if @submission.save
      redirect_to params[:redirect_to] ? "#{params[:redirect_to]}?submission_id=#{@submission.id}" : "/#{@project.name}?submission_id=#{@submission.id}"
    else
      redirect_to '/500.html'
    end
  end

  def update
    @submission = @project.submissions.find(params[:id])
    if @submission.update_attributes(params[:submission])
      redirect_to params[:redirect_to] ? "#{params[:redirect_to]}?submission_id=#{@submission.id}" : "/#{@project.name}?submission_id=#{@submission.id}"
    else
      redirect_to '/500.html'
    end
  end

  def submit
    @submission = Submission.find(params[:id])
    @project = @submission.project
    respond_to do |format|
      begin
        @submission.submit
        format.html  { redirect_to params[:redirect_to] || "/#{@project.name}" }
        format.json  { render json: @submission }
      rescue
        format.html  { redirect_to '/500.html' }
        format.json  { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end
end
