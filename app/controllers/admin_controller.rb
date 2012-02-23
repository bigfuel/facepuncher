class AdminController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_filter :load_project
  append_before_filter :authenticate_user!, :navigation
  layout 'admin'

  protected
  def load_project
    project_name = (controller_name == "projects") ? params[:id] : params[:project_id]
    @project = project_name && Project.find_by_name(project_name)
  end

  def navigation
    if @project
      begin
        @project_association_count = Rails.cache.read("project_association_count")
        Resque.enqueue(NavigationCache) unless @project_association_count
      rescue Exception => e
        logger.error "Can't read from Rails cache: #{e}"
        @project_association_count = nil
      end
    end
  end

  def sort_column
    params[:sort] || "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end