class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :load_project
  helper :application

  protected
  def load_project
    @project = params[:project_name] && Project.active.where(name: params[:project_name]).first
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private
  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    admin_root_path
  end
end