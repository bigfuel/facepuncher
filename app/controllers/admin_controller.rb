class AdminController < ApplicationController
  append_before_filter :authenticate_user!, :load_project
  layout 'admin'

  protected
  def load_project
    @project = params[:project_id] && Project.find_by_name(params[:project_id])
  end
end