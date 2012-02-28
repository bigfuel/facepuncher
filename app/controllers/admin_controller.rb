class AdminController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_project
  append_before_filter :authenticate_user!
  layout 'admin'

  protected
  def load_project
    project_name = (controller_name == "projects") ? params[:id] : params[:project_id]
    @project = project_name && Project.find_by_name(project_name)
  end

  def sort_column
    params[:sort] || "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end