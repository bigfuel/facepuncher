class AdminController < ApplicationController
  helper_method :sort_column, :sort_direction
  append_before_filter :authenticate_user!, :load_project
  layout 'admin'

  protected
  def load_project
    @project = params[:project_id] && Project.find_by_name(params[:project_id])
  end

  def sort_column
    params[:sort] || "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end