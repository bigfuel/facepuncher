class Api::SubmissionsController < ApplicationController
  before_filter :load_project, :check_for_project

  respond_to :json, :xml

  def index
    params[:sort_direction] ||= "asc"
    
    @submissions = @project.submissions
    @submissions = @submissions.where(state: params[:state]) if params[:state]
    @submissions = @submissions.order_by(params[:sort_column], params[:sort_direction]) if params[:sort_column]
    @submissions = @submissions.page(params[:page])
    @submissions = @submissions.per(params[:per_page]) if params[:per_page]

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
end
